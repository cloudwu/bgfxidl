function _G.doIdl()

	local gen = require "bgfx-codegen"

	local function gen(tempfile, outputfile, indent)
		local codes = gen.apply(tempfile)
		codes = gen.format(codes, {indent = indent})
		gen.write(codes, outputfile)
	end

	gen("temp.bgfx.h" , "../include/bgfx/c99/bgfx.h", "    " )
	gen.gen("temp.bgfx.idl.inl", "../src/bgfx.idl.inl", "\t" )

	os.exit()
end
