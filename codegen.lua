local codegen = {}

local function camelcase_to_underscorecase(name)
	local tmp = {}
	for v in name:gmatch "%u*[%l%d]+" do
		tmp[#tmp+1] = v:lower()
	end
	return table.concat(tmp, "_")
end

local function convert_typename(name)
	if name:match "^%u" then
		return "bgfx_" .. camelcase_to_underscorecase(name) .. "_t"	
	else
		return name
	end
end

local function convert_funcname(name)
	return camelcase_to_underscorecase(name)
end

local function convert_arg(all_types, arg)
	local t, postfix = arg.fulltype:match "(%a[%a%d_]*)%s+([*&]+)%s*$"
	if t then
		arg.type = t
		if postfix == "&" then
			arg.ref = true
		end
	else
		arg.type = arg.fulltype
	end
	local ctype = all_types[arg.type]
	if not ctype then
		error ("Undefined type " .. arg.type)
	end
	arg.ctype = arg.fulltype:gsub(arg.type, ctype.cname):gsub("&", "*")
	arg.cpptype = arg.fulltype:gsub(arg.type, "bgfx::"..arg.type)
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
	if ctype.handle then
		local aname = alternative_name(arg.name)
		arg.aname = aname .. ".cpp"
		arg.conversion = string.format(
			"union { %s c; bgfx::%s cpp; } %s = { %s };" ,
			ctype.cname, arg.type, aname, arg.name)
	elseif arg.ref then
		arg.aname = alternative_name(arg.name)
		arg.conversion = string.format(
			"%s %s = *(%s)%s;",
			arg.cpptype, arg.aname, arg.ptype, arg.name)
	else
		arg.aname = string.format(
			"(%s)%s",
			arg.cpptype, arg.name)
	end
end

local function gen_ret_conversion(all_types, func)
	if func.ret.fulltype == "void" then
		return
	end
	local ctype = all_types[func.ret.type]
	if ctype.handle then
		func.ret_conversion = string.format(
			"union { %s c; bgfx::%s cpp; } handle_ret;" ,
			ctype.cname, func.ret.type)
		func.ret_prefix = "handle_ret.cpp = "
		func.ret_postfix = "\n\treturn handle_ret.c;"
	else
		func.ret_prefix = string.format("return (%s)", func.ret.ctype)
	end
end

function codegen.nameconversion(all_types, all_funcs)
	for k,v in pairs(all_types) do
		if not v.cname then
			v.cname = convert_typename(k)
		end
	end

	for _,v in ipairs(all_funcs) do
		if v.attribs == nil then
			v.attribs = { cname = convert_funcname(v.name) }
		elseif v.attribs.cname == nil then
			v.attribs.cname = convert_funcname(v.name)
		end
		for _, arg in ipairs(v.args) do
			convert_arg(all_types, arg)
			gen_arg_conversion(all_types, arg)
		end
		convert_arg(all_types, v.ret)
		gen_ret_conversion(all_types, v)
	end
end

local c99temp = [[
BGFX_C_API $RET bgfx_$FUNCNAME($ARGS)
{
	$CONVERSION
	$PRERET$CPPFUNC($CALLARGS);$POSTRET
}
]]

function codegen.genc99(func)
	local conversion = {}
	local args = {}
	local callargs = {}
	for _, arg in ipairs(func.args) do
		conversion[#conversion+1] = arg.conversion
		args[#args+1] = arg.ctype .. " " .. arg.name
		callargs[#callargs+1] = arg.aname
	end
	conversion[#conversion+1] = func.ret_conversion
	local temp = {
		RET = func.ret.ctype,
		FUNCNAME = func.attribs.cname,
		ARGS = table.concat(args, ", "),
		CONVERSION = table.concat(conversion, "\n\t"),
		PRERET = func.ret_prefix or "",
		CPPFUNC = "bgfx::" .. func.name,
		CALLARGS = table.concat(callargs, ", "),
		POSTRET = func.ret_postfix or "",
	}
	return c99temp:gsub("$(%u+)", temp)
end

return codegen
