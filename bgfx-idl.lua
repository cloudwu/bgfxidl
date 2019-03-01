-- Copyright 2019 云风 https://github.com/cloudwu . All rights reserved.
-- License (the same with bgfx) : https://github.com/bkaradzic/bgfx/blob/master/LICENSE

local idl     = require "idl"
local codegen = require "codegen"
local doxygen = require "doxygen"

local paths = (...) or {
	["bgfx.idl.h"] = "../include/bgfx/c99",
	["bgfx.idl.inl"] = "../src",
	-- todo: cpp header path here
	["bgfx.types.h"] = ".",
}

local func_actions = {
	c99 = "\n",
	c99decl = "\n",
	interface_struct = "\n\t",
	interface_import = ",\n\t\t\t",
}

local type_actions = {
	enums = "\n",
	cenums = "\n",
	structs = "\n",
	cstructs = "\n",
}

assert(loadfile("bgfx.idl" , "t", idl))()

doxygen.import "bgfx.idl"
codegen.nameconversion(idl.types, idl.funcs)

local typegen = {}

local function add_doxygen(typedef, define, cstyle)
		local func = cstyle and codegen.doxygen_ctype or codegen.doxygen_type
		local doc = func(typedef, idl.comments[typedef.name])
		if doc then
			return doc .. "\n" .. define
		else
			return define
		end
end

function typegen.enums(typedef)
	if typedef.enum then
		return add_doxygen(typedef, codegen.gen_enum_define(typedef))
	end
end

function typegen.cenums(typedef)
	if typedef.enum then
		return add_doxygen(typedef, codegen.gen_enum_cdefine(typedef), true)
	end
end

function typegen.structs(typedef)
	if typedef.struct then
		-- todo: nest struct
		if not typedef.namespace then
			return add_doxygen(typedef, codegen.gen_struct_define(typedef))
		end
	end
end

function typegen.cstructs(typedef)
	if typedef.struct then
		return add_doxygen(typedef, codegen.gen_struct_cdefine(typedef), true)
	end
end

-- For bgfx.idl.h
local code_temp_include = [[
/*
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

/*
 *
 * AUTO GENERATED! DO NOT EDIT!
 *
 */

$cenums
$cstructs
$c99decl
/**/
typedef struct bgfx_interface_vtbl
{
	$interface_struct
} bgfx_interface_vtbl_t;
]]

-- For bgfx.idl.inl
local code_temp_impl = [[
/*
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

/*
 *
 * AUTO GENERATED! DO NOT EDIT!
 *
 */

$c99
/**/
BGFX_C_API bgfx_interface_vtbl_t* bgfx_get_interface(uint32_t _version)
{
	if (_version == BGFX_API_VERSION)
	{
		static bgfx_interface_vtbl_t s_bgfx_interface =
		{
			$interface_import
		};

		return &s_bgfx_interface;
	}

	return NULL;
}
]]

-- For bgfx.types.h
local code_temp_enums = [[
$enums
$structs
]]

local function codes()
	local temp = {}
	for k in pairs(func_actions) do
		temp[k] = {}
	end

	for k in pairs(type_actions) do
		temp[k] = {}
	end

	-- call actions with func
	for _, f in ipairs(idl.funcs) do
		for k in pairs(func_actions) do
			local funcgen = codegen["gen_"..k]
			if funcgen then
				table.insert(temp[k], (funcgen(f)))
			end
		end
	end

	-- call actions with type

	for _, typedef in ipairs(idl.types) do
		for k in pairs(type_actions) do
			local typegen = typegen[k]
			if typegen then
				table.insert(temp[k], (typegen(typedef)))
			end
		end
	end

	for k, ident in pairs(func_actions) do
		temp[k] = table.concat(temp[k], ident)
	end
	for k, ident in pairs(type_actions) do
		temp[k] = table.concat(temp[k], ident)
	end

	return temp
end

local codes_tbl = codes()

local function add_path(filename)
	local path
	if type(paths) == "string" then
		path = paths
	else
		path = assert(paths[filename])
	end
	return path .. "/" .. filename
end

for filename, temp in pairs {
	[add_path "bgfx.idl.h"] = code_temp_include ,
	[add_path "bgfx.idl.inl"] = code_temp_impl ,
	[add_path "bgfx.types.h"] = code_temp_enums ,
	} do

	print ("Generate " .. filename)
	local out = assert(io.open(filename, "wb"))
	out:write((temp:gsub("$([%l%d_]+)", codes_tbl)))
	out:close()
end
