-- Copyright 2019 云风 https://github.com/cloudwu . All rights reserved.
-- License (the same with bgfx) : https://github.com/bkaradzic/bgfx/blob/master/LICENSE

local idl     = require "idl"
local codegen = require "codegen"
local doxygen = require "doxygen"

do local _ENV = idl
	typedef "bool"
	typedef "void"
	typedef "uint8_t"
	typedef "uint16_t"
	typedef "char"
	typedef "va_list"

	typedef "Memory"
	typedef "VertexDecl"

	comment.Attrib "Vertex attribute enum."
	enum.Attrib               { comment = "Corresponds to vertex shader attribute." }
		.Position  "a_position"
		.Normal    "a_normal"
		.Tangent   "a_tangent"
		.Bitangent "a_bitangent"
		.Color0    "a_color0"
		.Color1    "a_color1"
		.Color2    "a_color2"
		.Color3    "a_color3"
		.Indices   "a_indices"
		.Weight    "a_weight"
		.TexCoord0 "a_texcoord0"
		.TexCoord1 "a_texcoord1"
		.TexCoord2 "a_texcoord2"
		.TexCoord3 "a_texcoord3"
		.TexCoord4 "a_texcoord4"
		.TexCoord5 "a_texcoord5"
		.TexCoord6 "a_texcoord6"
		.TexCoord7 "a_texcoord7"

	enum "AttribType"

	handle "IndexBufferHandle"

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

--doxygen.import "bgfx.idl"

for typename, v in pairs(idl.types) do
	print("TYPE:", typename, v.cname)
	print(codegen.doxygen_type(v, idl.comments[v.name]))
	if v.enum then
		print(codegen.typegen_enums(v))
	end
end

--[[

for _, v in ipairs(idl.funcs) do
	print((codegen.gen_c99(v)))
end
]]