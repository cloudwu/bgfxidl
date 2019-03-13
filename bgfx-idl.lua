function _G.doIdl()

	local gen = require "bgfx-codegen"

	gen.gen("temp.bgfx.h" , "../include/bgfx/c99/bgfx.h", "    " )
	gen.gen("temp.bgfx.idl.inl", "../src/bgfx.idl.inl", "\t" )

	os.exit()
end
