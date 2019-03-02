-- Copyright 2019 云风 https://github.com/cloudwu . All rights reserved.
-- License (the same with bgfx) : https://github.com/bkaradzic/bgfx/blob/master/LICENSE

local idl     = require "idl"
local codegen = require "codegen"
local doxygen = require "doxygen"

local files = {
	["bgfx.h"] = "../include/bgfx/c99",
	["bgfx.idl.inl"] = "../src",
	-- todo: cpp header path here
	["bgfx.idl.cpp"] = ".",
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
	handles = "\n",
	chandles = "\n",
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
	if typedef.struct and not typedef.namespace then
		return add_doxygen(typedef, codegen.gen_struct_define(typedef))
	end
end

function typegen.cstructs(typedef)
	if typedef.struct then
		return add_doxygen(typedef, codegen.gen_struct_cdefine(typedef), true)
	end
end

function typegen.handles(typedef)
	if typedef.handle then
		return codegen.gen_handle(typedef)
	end
end

function typegen.chandles(typedef)
	if typedef.handle then
		return codegen.gen_chandle(typedef)
	end
end

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

local function genidl(filename, path)
	local tempfile = "temp." .. filename
	local outputfile = path .. "/" .. filename
	print ("Generate", outputfile, "from", tempfile)
	local f = assert(io.open(tempfile, "rb"))
	local temp = f:read "a"
	f:close()
	local out = assert(io.open(outputfile, "wb"))
	codes_tbl.source = tempfile
	out:write((temp:gsub("$([%l%d_]+)", codes_tbl)))
	out:close()
end

for filename, path in pairs (files) do
	path = (...) or path
	genidl(filename, path)
end
