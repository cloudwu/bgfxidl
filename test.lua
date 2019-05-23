-- Copyright 2019 云风 https://github.com/cloudwu . All rights reserved.
-- License (the same with bgfx) : https://github.com/bkaradzic/bgfx/blob/master/LICENSE

local gen = require "bgfx-codegen"

local path = (...)

local files = {
	{ temp = "temp.bgfx.h" , output = "../include/bgfx/c99/bgfx.h", indent = "    " },
	{ temp = "temp.bgfx.idl.inl", output = "../src/bgfx.idl.inl" },
	{ temp = "temp.bgfx.hpp", output = "./bgfx.hpp" },
	{ temp = "temp.bgfx.shim.cpp", output = "./bgfx.shim.cpp" },
	{ temp = "temp.defines.h", output = "./defines.h" },
}

for _, f in ipairs (files) do
	local output = f.output
	if path then
		output = output:gsub(".-(/[^/]+)$", path .. "%1")
	end
	gen.gen(f.temp, output, f.indent or "\t")
end
