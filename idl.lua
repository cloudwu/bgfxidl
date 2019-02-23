local idl = {}

local all_types = {}

local function typedef(_, typename)
	assert(all_types[typename] == nil, "Duplicate type")
	local t = {}
	all_types[typename] = t
	local function type_attrib(attrib)
		assert(type(attrib) == "table", "type attrib should be a table")
		for _, a in ipairs(attrib) do
			t[a] = true
		end
	end
	return function(cname)
		local typ = type(cname)
		if typ == "table" then
			type_attrib(cname)
			return
		end
		assert(typ == "string" , "type should be a string")
		t.cname = cname
		return type_attrib
	end
end

idl.typedef = setmetatable({} , { __index = typedef, __call = typedef })
idl.types = all_types

local all_funcs = {}

local function duplicate_arg_name(name)
	error ("Duplicate arg name " .. name)
end

local function funcdef(_, funcname)
	local f = { name = funcname , args = {} }
	all_funcs[#all_funcs+1] = f
	local args
	local function args_desc(obj, args_name)
		obj[args_name] = duplicate_arg_name
		return function (fulltype)
			f.args[#f.args+1] = {
				name = args_name,
				fulltype = fulltype,
			}
			return args
		end
	end
	args = setmetatable({}, { __index = args_desc })
	local function rettype(value)
		assert(type(value) == "string", "Need return type")
		f.ret = { fulltype = value }
		return args
	end
	return function(value)
		if type(value) == "table" then
			f.attribs = value
			return rettype
		end
		return rettype(value)
	end
end

idl.func = setmetatable({}, { __index = funcdef })
idl.funcs = all_funcs

return idl
