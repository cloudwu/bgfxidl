-- Copyright 2019 云风 https://github.com/cloudwu . All rights reserved.
-- License (the same with bgfx) : https://github.com/bkaradzic/bgfx/blob/master/LICENSE

local codegen = {}

local NAMEALIGN = 20

local function namealign(name, align)
	align = align or NAMEALIGN
	return string.rep(" ", align - #name)
end

local function camelcase_to_underscorecase(name)
	local tmp = {}
	for v in name:gmatch "[%u%d]+%l*" do
		tmp[#tmp+1] = v:lower()
	end
	return table.concat(tmp, "_")
end

local function convert_funcname(name)
	name = name:gsub("^%l", string.upper)	-- Change to upper CamlCase
	return camelcase_to_underscorecase(name)
end

local function convert_arg(all_types, arg, namespace)
	local fulltype, array = arg.fulltype:match "(.-)%s*(%[%s*[%d%a_:]*%s*%])"
	if array then
		arg.fulltype = fulltype
		arg.array = array
		local enum, value = array:match "%[%s*([%a%d]+)::([%a%d]+)%]"
		if enum then
			local typedef = all_types[ enum .. "::Enum" ]
			if typedef == nil then
				error ("Unknown Enum " .. enum)
			end
			arg.carray = "[BGFX_" .. camelcase_to_underscorecase(enum):upper() .. "_" .. value:upper() .. "]"
		end
	end
	local t, postfix = arg.fulltype:match "(%a[%a%d_:]*)%s*([*&]+)%s*$"
	if t then
		arg.type = t
		if postfix == "&" then
			arg.ref = true
		end
	else
		local prefix, t = arg.fulltype:match "^%s*(%a+)%s+(%S+)"
		if prefix then
			arg.type = t
		else
			arg.type = arg.fulltype
		end
	end
	local ctype
	local substruct = namespace.substruct
	if substruct then
		ctype = substruct[arg.type]
	end
	if not ctype then
		ctype = all_types[arg.type]
	end
	if not ctype then
		error ("Undefined type " .. arg.fulltype .. " in " .. namespace.name)
	end
	arg.ctype = arg.fulltype:gsub(arg.type, ctype.cname):gsub("&", "*")
	if ctype.cname ~= arg.type then
		arg.cpptype = arg.fulltype:gsub(arg.type, "bgfx::"..arg.type)
	else
		arg.cpptype = arg.fulltype
	end
	if arg.ref then
		arg.ptype = arg.cpptype:gsub("&", "*")
	end
end

local function alternative_name(name)
	if name:sub(1,1) == "_" then
		return name:sub(2)
	else
		return name .. "_"
	end
end

local function gen_arg_conversion(all_types, arg)
	if arg.ctype == arg.fulltype then
		-- do not need conversion
		arg.aname = arg.name
		return
	end
	local ctype = all_types[arg.type]
	if ctype.handle and arg.type == arg.fulltype then
		local aname = alternative_name(arg.name)
		arg.aname = aname .. ".cpp"
		arg.conversion = string.format(
			"union { %s c; bgfx::%s cpp; } %s = { %s };" ,
			ctype.cname, arg.type, aname, arg.name)
	elseif arg.ref then
		if ctype.cname == arg.type then
			arg.aname = "*" .. arg.name
		elseif arg.out and ctype.enum then
			local aname = alternative_name(arg.name)
			local cpptype = arg.cpptype:match "(.-)%s*&"	-- remove &
			arg.aname = aname
			arg.conversion = string.format("%s %s;", cpptype, aname)
			arg.out_conversion = string.format("*%s = (%s)%s;", arg.name, ctype.cname, aname)
		else
			arg.aname = alternative_name(arg.name)
			arg.conversion = string.format(
				"%s %s = *(%s)%s;",
				arg.cpptype, arg.aname, arg.ptype, arg.name)
		end
	else
		local cpptype = arg.cpptype
		if arg.array then
			cpptype = cpptype .. "*"
		end
		arg.aname = string.format(
			"(%s)%s",
			cpptype, arg.name)
	end
end

local function gen_ret_conversion(all_types, func)
	local postfix = { func.vararg and "va_end(argList);" }
	func.ret_postfix = postfix

	for _, arg in ipairs(func.args) do
		if arg.out_conversion then
			postfix[#postfix+1] = arg.out_conversion
		end
	end

	local ctype = all_types[func.ret.type]
	if ctype.handle then
		func.ret_conversion = string.format(
			"union { %s c; bgfx::%s cpp; } handle_ret;" ,
			ctype.cname, func.ret.type)
		func.ret_prefix = "handle_ret.cpp = "
		postfix[#postfix+1] = "return handle_ret.c;"
	elseif func.ret.fulltype ~= "void" then
		local ctype_conversion = func.ret.type == func.ret.ctype and "" or ("(" ..  func.ret.ctype .. ")")
		if #postfix > 0 then
			func.ret_prefix = string.format("%s retValue = %s", func.ret.ctype , ctype_conversion)
			postfix[#postfix+1] = "return retValue;"
		else
			func.ret_prefix = string.format("return %s", ctype_conversion)
		end
	end
end

local function convert_vararg(v)
	if v.vararg then
		local args = v.args
		local vararg = {
			name = "",
			type = "...",
			ctype = "...",
			aname = "argList",
			conversion = string.format(
				"va_list argList;\n\tva_start(argList, %s);",
				args[#args].name),
		}
		args[#args + 1] = vararg
		v.implname = v.vararg
	else
		v.implname = v.name
	end
end

function codegen.nameconversion(all_types, all_funcs)
	for _,v in ipairs(all_types) do
		local name = v.name
		local cname = v.cname
		if cname == nil then
			if name:match "^%u" then
				cname = camelcase_to_underscorecase(name)
			else
				v.cname = name
			end
		end
		if cname then
			if v.namespace then
				cname = camelcase_to_underscorecase(v.namespace) .. "_" .. cname
			end
			v.cname = "bgfx_".. cname .. "_t"
		end
		if v.enum then
			v.name = v.name .. "::Enum"
		end
	end

	-- make index
	for _,v in ipairs(all_types) do
		if not v.namespace then
			if all_types[v.name] then
				error ("Duplicate type " .. v.name)
			end
			all_types[v.name] = v
		end
	end

	-- make sub struct index
	for _,v in ipairs(all_types) do
		if v.namespace then
			local super = all_types[v.namespace]
			if not super then
				error ("Define " .. v.namespace .. " first")
			end
			local substruct = super.substruct
			if not substruct then
				substruct = {}
				super.substruct = substruct
			end
			if substruct[v.name] then
				error ( "Duplicate sub struct " .. v.name .. " in " .. v.namespace)
			end
			substruct[#substruct+1] = v
			substruct[v.name] = v
		end
	end

	for _,v in ipairs(all_types) do
		if v.struct then
			for _, item in ipairs(v.struct) do
				convert_arg(all_types, item, v)
			end
		elseif v.args then
			for _, arg in ipairs(v.args) do
				convert_arg(all_types, arg, v)
			end
			convert_vararg(v)
			convert_arg(all_types, v.ret, v)
		end
	end

	for _,v in ipairs(all_funcs) do
		if v.cname == nil then
			v.cname = convert_funcname(v.name)
		end
		if v.class then
			v.cname = convert_funcname(v.class) .. "_" .. v.cname
		end
		for _, arg in ipairs(v.args) do
			convert_arg(all_types, arg, v)
			gen_arg_conversion(all_types, arg)
		end
		convert_vararg(v)
		convert_arg(all_types, v.ret, v)
		gen_ret_conversion(all_types, v)
		if namespace then
			local classname = namespace
			if v.const then
				classname = "const " .. classname
			end
			local classtype = { fulltype = classname .. "*" }
			convert_arg(all_types, classtype, v)
			v.this = classtype.ctype .. " _this"
			v.this_conversion = string.format( "%s This = (%s)_this;", classtype.cpptype, classtype.cpptype)
		end
	end
end

local function lines(tbl)
	if not tbl or #tbl == 0 then
		return "//EMPTYLINE"
	else
		return table.concat(tbl, "\n\t")
	end
end

local function remove_emptylines(txt)
	return (txt:gsub("\t//EMPTYLINE\n", ""))
end

local function codetemp(func)
	local conversion = {}
	local args = {}
	local cargs = {}
	local callargs = {}
	local cppfunc
	if func.class then
		-- It's a member function
		cargs[1] = func.this
		conversion[1] = func.this_conversion
		cppfunc = "This->" .. func.name
	else
		cppfunc = "bgfx::" .. tostring(func.implname)
	end
	for _, arg in ipairs(func.args) do
		conversion[#conversion+1] = arg.conversion
		local cname = arg.ctype .. " " .. arg.name
		if arg.array then
			cname = cname .. (arg.carray or arg.array)
		end
		local name = arg.type .. " " .. arg.name
		if arg.array then
			name = name .. arg.array
		end
		cargs[#cargs+1] = cname
		args[#args+1] = name
		callargs[#callargs+1] = arg.aname
	end
	conversion[#conversion+1] = func.ret_conversion

	return {
		RET = func.ret.ctype,
		CFUNCNAME = func.cname,
		FUNCNAME = func.name,
		CARGS = table.concat(cargs, ", "),
		ARGS = table.concat(args, ", "),
		CONVERSION = lines(conversion),
		PRERET = func.ret_prefix or "",
		CPPFUNC = cppfunc,
		CALLARGS = table.concat(callargs, ", "),
		POSTRET = lines(func.ret_postfix),
		CODE = func.cfunc,
	}
end

local function apply_template(func, temp)
	func.codetemp = func.codetemp or codetemp(func)
	return (temp:gsub("$(%u+)", func.codetemp))
end

local c99temp = [[
BGFX_C_API $RET bgfx_$CFUNCNAME($CARGS)
{
	$CONVERSION
	$PRERET$CPPFUNC($CALLARGS);
	$POSTRET
}
]]

local c99usertemp = [[
BGFX_C_API $RET bgfx_$CFUNCNAME($CARGS)
{
$CODE
}
]]

function codegen.gen_c99(func)
	if func.cfunc then
		return apply_template(func, c99usertemp)
	else
		return remove_emptylines(apply_template(func, c99temp))
	end
end

local template_function_declaration = [[
/**/
BGFX_C_API $RET bgfx_$CFUNCNAME($CARGS);
]]

function codegen.gen_c99decl(func)
	return apply_template(func, template_function_declaration)
end

function codegen.gen_funcptr(funcptr)
	return apply_template(funcptr, "typedef $RET (*$FUNCNAME)($ARGS);")
end

function codegen.gen_cfuncptr(funcptr)
	return apply_template(funcptr, "typedef $RET (*$CFUNCNAME)($CARGS);")
end

function codegen.gen_interface_struct(func)
	return apply_template(func, "$RET (*$CFUNCNAME)($CARGS);")
end

function codegen.gen_interface_import(func)
	return "bgfx_" .. func.cname
end

function codegen.doxygen_type(typedef, doxygen)
	if doxygen == nil then
		return
	end
	local result = {}
	for _, line in ipairs(doxygen) do
		result[#result+1] = "/// " .. line
	end
	result[#result+1] = "///"
	result[#result+1] = string.format("/// @attention C99 equivalent is `%s`.", typedef.cname)
	result[#result+1] = "///"
	return table.concat(result, "\n")
end

function codegen.doxygen_ctype(typedef, doxygen)
	if doxygen == nil then
		return
	end
	local result = {
		"/**",
	}
	for _, line in ipairs(doxygen) do
		result[#result+1] = " * " .. line
	end
	result[#result+1] = " */"
	return table.concat(result, "\n")
end

local enum_temp = [[
struct $NAME
{
	$COMMENT
	enum Enum
	{
		$ITEMS

		Count
	};
};
]]

function codegen.gen_enum_define(enum)
	assert(type(enum.enum) == "table", "Not an enum")
	local items = {}
	for _, item in ipairs(enum.enum) do
		local text
		if not item.comment then
			text = item.name .. ","
		else
			text = string.format("%s,%s //!< %s",
				item.name, namealign(item.name), item.comment)
		end
		items[#items+1] = text
	end
	local comment = ""
	if enum.comment then
		comment = "/// " .. enum.comment
	end
	local temp = {
		NAME = enum.name,
		COMMENT = comment,
		ITEMS = table.concat(items, "\n\t\t"),
	}
	return (enum_temp:gsub("$(%u+)", temp))
end

local cenum_temp = [[
typedef enum $NAME
{
	$ITEMS

	$COUNT

} $NAME_t;
]]
function codegen.gen_enum_cdefine(enum)
	assert(type(enum.enum) == "table", "Not an enum")
	local cname = enum.cname:match "(.-)_t$"
	local uname = cname:upper()
	local items = {}
	for index , item in ipairs(enum.enum) do
		local comment = item.comment or ""
		local ename = item.cname
		if not ename then
			if enum.underscore then
				ename = camelcase_to_underscorecase(item.name)
			else
				ename = item.name
			end
			ename = ename:upper()
		end
		local name = uname .. "_" .. ename
		items[#items+1] = string.format("%s,%s /** (%2d) %s%s */",
			name,
			namealign(name, 40),
			index - 1,
			comment,
			namealign(comment, 30))
	end

	local temp = {
		NAME = cname,
		COUNT = uname .. "_COUNT",
		ITEMS = table.concat(items, "\n\t"),
	}

	return (cenum_temp:gsub("$(%u+)", temp))
end

local function strip_space(c)
	return (c:match "(.-)%s*$")
end

local function text_with_comments(items, item, cstyle)
	local name = item.name
	if item.array then
		if cstyle then
			name = name .. (item.carray or item.array)
		else
			name = name .. item.array
		end
	end
	local typename
	if cstyle then
		typename = item.ctype
	else
		typename = item.fulltype
	end
	local text = string.format("%s%s %s;", typename, namealign(typename), name)
	if item.comment then
		if type(item.comment) == "table" then
			table.insert(items, "")
			if cstyle then
				table.insert(items, "/**")
				for _, c in ipairs(item.comment) do
					table.insert(items, " * " .. strip_space(c))
				end
				table.insert(items, " */")
			else
				for _, c in ipairs(item.comment) do
					table.insert(items, "/// " .. strip_space(c))
				end
			end
		else
			text = string.format(
				cstyle and "%s %s/** %s%s */" or "%s %s//!< %s",
				text, namealign(text, 40),  item.comment, namealign(item.comment, 40))
		end
	end
	items[#items+1] = text
end

local struct_temp = [[
struct $NAME
{
	$CTOR
	$SUBSTRUCTS
	$ITEMS
};
]]

function codegen.gen_struct_define(struct)
	assert(type(struct.struct) == "table", "Not a struct")
	local items = {}
	for _, item in ipairs(struct.struct) do
		text_with_comments(items, item)
	end
	local ctor = {}
	if struct.ctor then
		ctor[1] = struct.name .. "();"
		ctor[2] = ""
	end
	local subs = {}
	if struct.substruct then
		for _, v in ipairs(struct.substruct) do
			local s = codegen.gen_struct_define(v)
			s = s:gsub("\n", "\n\t")
			subs[#subs+1] = s
		end
	end

	local temp = {
		NAME = struct.name,
		SUBSTRUCTS = lines(subs),
		ITEMS = table.concat(items, "\n\t"),
		CTOR = lines(ctor),
	}
	return remove_emptylines(struct_temp:gsub("$(%u+)", temp))
end

local cstruct_temp = [[
typedef struct $NAME_s
{
	$ITEMS

} $NAME_t;
]]
function codegen.gen_struct_cdefine(struct)
	assert(type(struct.struct) == "table", "Not a struct")
	local cname = struct.cname:match "(.-)_t$"
	local items = {}
	for _, item in ipairs(struct.struct) do
		text_with_comments(items, item, true)
	end
	local temp = {
		NAME = cname,
		ITEMS = table.concat(items, "\n\t"),
	}
	return (cstruct_temp:gsub("$(%u+)", temp))
end

local chandle_temp = [[
typedef struct $NAME_s { uint16_t idx; } $NAME_t;
]]
function codegen.gen_chandle(handle)
	assert(handle.handle, "Not a handle")
	return (chandle_temp:gsub("$(%u+)", { NAME = handle.cname:match "(.-)_t$" }))
end

local handle_temp = [[
struct $NAME { uint16_t idx; };
inline bool isValid($NAME _handle) { return bgfx::kInvalidHandle != _handle.idx; }
]]
function codegen.gen_handle(handle)
	assert(handle.handle, "Not a handle")
	return (handle_temp:gsub("$(%u+)", { NAME = handle.name }))
end

return codegen
