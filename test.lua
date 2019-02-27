-- Copyright 2019 云风 https://github.com/cloudwu . All rights reserved.
-- License (the same with bgfx) : https://github.com/bkaradzic/bgfx/blob/master/LICENSE

local idl     = require "idl"
local codegen = require "codegen"

do local _ENV = idl
	typedef "bool"
	typedef "void"
	typedef "uint8_t"
	typedef "uint16_t"
	typedef "char"
	typedef "va_list"

	typedef "Memory"
	typedef "VertexDecl"

	typedef.Attrib               { enum }
	typedef.AttribType           { enum }

	typedef.IndexBufferHandle         { handle }

	func.VertexDecl.decode { const }
		"void"
		.attrib          "Attrib::Enum"
		.num             "uint8_t &"          { out }
		.type            "AttribType::Enum &" { out }
		.normalized      "bool &"             { out }
		.asInt           "bool &"             { out }

	func.dbgTextPrintf { vararg = "dbgTextPrintfVargs" }
		"void"
		.x      "uint16_t"
		.y      "uint16_t"
		.attr   "uint8_t"
		.format "const char *"

	func.dbgTextPrintfVargs { cname = "dbg_text_vprintf" }
		"void"
		.x       "uint16_t"
		.y       "uint16_t"
		.attr    "uint8_t"
		.format  "const char *"
		.argList "va_list"

	func.createIndexBuffer
		"IndexBufferHandle"
		.mem   "const Memory *"
		.flags "uint16_t"

end

codegen.nameconversion(idl.types, idl.funcs)

for typename, v in pairs(idl.types) do
	print("TYPE:", typename, v.cname)
end

for _, v in ipairs(idl.funcs) do
	print((codegen.gen_c99(v)))
end
