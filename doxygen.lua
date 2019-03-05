local idl = require "idl"

local doxygen = {}

local idl_defines = {
	func = true,
	typedef = true,
	enum = true,
	handle = true,
	struct = true,
	funcptr = true,
}

local function import(filename)
	local doxygen = {}
	for line in io.lines(filename) do
		local comment = line:match "^%-%-%-%s*(.*)"
		if comment then
			doxygen[#doxygen+1] = comment
		else
			local what, typename = line:match "^%s*(%l+)[. %[]\"?([%a%d]+%.?[%a%d]*)"
			if typename and idl_defines[what] then
				local cname = line:match [[{%s*cname%s*=%s*["']([%a%d_]+)]]
				for _, c in ipairs(doxygen) do
					if cname then
						idl.comment[typename](cname, c)
					else
						idl.comment[typename](c)
					end
				end
				doxygen = {}
			elseif line:match "%S" and #doxygen > 0 then
				break
			end
		end
	end
	if #doxygen > 0 then
		error ( "Unknown doxygens :\n" .. table.concat(doxygen, "\n") )
	end
end

function doxygen.load(filename)
	import(filename)
	local f = assert(io.open(filename, "rb"))
	local text = f:read "a"
	text = text:gsub("([^\n\r])%-%-%-[ \t](.-)\n", "%1[[%2]]\n")
	f:close()
	return text
end


return doxygen
