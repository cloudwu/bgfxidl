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

function doxygen.import(filename)
	local doxygen = {}
	for line in io.lines(filename) do
		local comment = line:match "^%s*%-%-%-%s*(.*)"
		if comment then
			doxygen[#doxygen+1] = comment
		else
			local what, typename = line:match "^%s*(%l+)[. %[]\"?([%a%d]+%.?[%a%d]*)"
			if typename and idl_defines[what] then
				for _, c in ipairs(doxygen) do
					idl.comment[typename](c)
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
	return docs
end

return doxygen
