-- Copyright 2019 云风 https://github.com/cloudwu . All rights reserved.
-- License (the same with bgfx) : https://github.com/bkaradzic/bgfx/blob/master/LICENSE

local idl     = require "idl"
local codegen = require "codegen"
local doxygen = require "doxygen"

local func_actions = {
	c99 = "\n",
	c99decl = "\n",
	cppdecl = "\n",
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
	funcptrs = "\n",
	cfuncptrs = "\n",
}

assert(loadfile("bgfx.idl" , "t", idl))()

doxygen.import "bgfx.idl"
codegen.nameconversion(idl.types, idl.funcs)

local function cfunc(f)
	return function(func)
		if not func.cpponly then
			return f(func)
		end
	end
end

local funcgen = {
	c99 = cfunc(codegen.gen_c99),
	c99decl = cfunc(codegen.gen_c99decl),
	interface_struct = cfunc(codegen.gen_interface_struct),
}

funcgen.interface_import = cfunc(function(func)
	return "bgfx_" .. func.cname
end)

local function cppdecl(func)
	local doc_key = func.name
	if func.class then
		doc_key = func.class .. "." .. doc_key
	end
	local doc = idl.comments[doc_key]
	if not doc and func.comment then
		doc = { func.comment }
	end
	if doc then
		local cname
		if not func.cpponly then
			if func.multicfunc then
				cname = {}
				for _, name in ipairs(func.multicfunc) do
					cname[#cname+1] = "bgfx_" .. name
				end
			else
				cname = "bgfx_" .. func.cname
			end
		end
		if func.cusername then
			doc = doc[func.cusername]
		end
		local text = codegen.doxygen_type(doc, cname)
		if text then
			return text .. "\n" .. codegen.gen_cppdecl(func) .. "\n"
		end
	else
		return codegen.gen_cppdecl(func) .. "\n"
	end
end

function funcgen.cppdecl(func)
	-- Don't generate member functions here
	if not func.class then
		return cppdecl(func)
	end
end

local typegen = {}

local function add_doxygen(typedef, define, cstyle, cname)
		local func = cstyle and codegen.doxygen_ctype or codegen.doxygen_type
		local doc = func(idl.comments[typedef.name], cname or typedef.cname)
		if doc then
			return doc .. "\n" .. define
		else
			return define
		end
end

function typegen.enums(typedef)
	if typedef.enum then
		return add_doxygen(typedef, codegen.gen_enum_define(typedef), false, "bgfx_" .. typedef.cname)
	end
end

function typegen.cenums(typedef)
	if typedef.enum then
		return add_doxygen(typedef, codegen.gen_enum_cdefine(typedef), true)
	end
end

function typegen.structs(typedef)
	if typedef.struct and not typedef.namespace then
		local methods = typedef.methods
		if methods then
			local m = {}
			for _, func in ipairs(methods) do
				m[#m+1] = cppdecl(func)
			end
			methods = m
		end
		return add_doxygen(typedef, codegen.gen_struct_define(typedef, methods))
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

function typegen.funcptrs(typedef)
	if typedef.args then
		return add_doxygen(typedef, codegen.gen_funcptr(typedef))
	end
end

function typegen.cfuncptrs(typedef)
	if typedef.args then
		return add_doxygen(typedef, codegen.gen_cfuncptr(typedef), true)
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
			local funcgen = funcgen[k]
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

local function genidl(filename, outputfile)
	local tempfile = "temp." .. filename
	print ("Generate", outputfile, "from", tempfile)
	local f = assert(io.open(tempfile, "rb"))
	local temp = f:read "a"
	f:close()
	local out = assert(io.open(outputfile, "wb"))
	codes_tbl.source = tempfile
	out:write((temp:gsub("$([%l%d_]+)", codes_tbl)))
	out:close()
end


local files = {
	["bgfx.h"] = "../include/bgfx/c99",
	["bgfx.idl.inl"] = "../src",
	["bgfx.hpp"] = ".",
}

for filename, path in pairs (files) do
	path = (...) or path
	genidl(filename, path .. "/" .. filename)
end
