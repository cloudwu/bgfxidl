local idl     = require "idl"
local codegen = require "codegen"

do local _ENV = idl
	typedef "void"
	typedef "bool"
	typedef "char"
	typedef "float"
	typedef "int32_t"
	typedef "uint8_t"
	typedef "uint16_t"
	typedef "uint32_t"
	typedef "uint64_t"
	typedef "Attrib::Enum"
	typedef "RendererType::Enum"
	typedef "TextureFormat::Enum"
	typedef "Caps"
	typedef "Init"
	typedef "Memory"
	typedef "Stats"
	typedef "VertexDecl"
	typedef.VertexBufferHandle { "handle" }
	typedef.IndexBufferHandle  { "handle" }

	func.vertexPack
		"void"
		.input           "const float *"
		.inputNormalized "bool"
		.attr            "Attrib::Enum"
		.decl            "const VertexDecl &"
		.data            "void *"
		.index           "uint32_t"

	func.init
		"bool"
		.init "const Init &"

	func.shutdown
		"void"

	func.reset
		"void"
		.width  "uint32_t"
		.height "uint32_t"
		.flags  "uint32_t"
		.format "TextureFormat::Enum"

	func.frame
		"void"
		.capture "bool"

	func.getRendererType
		"RendererType::Enum"

	func.getCaps
		"const Caps *"

	func.getStats
		"const Stats *"

	func.alloc
		"const Memory *"
		.size "uint32_t"

	func.copy
		"const Memory *"
		.data "const void *"
		.size "uint32_t"

	func.makeRef
		"const Memory *"
		.data "const void *"
		.size "uint32_t"

	func.setDebug
		"void"
		.debug "uint32_t"

	func.dbgTextClear
		"void"
		.attr  "uint8_t"
		.small "bool"

	func.createIndexBuffer
		"IndexBufferHandle"
		.mem   "const Memory *"
		.flags "uint16_t"

	func.setName { cname = "set_index_buffer_name" }
		"void"
		.handle "IndexBufferHandle"
		.name   "const char *"
		.len    "int32_t"

	func.destroy { cname = "destroy_index_buffer" }
		"void"
		.handle "IndexBufferHandle"

	func.createVertexBuffer
		"VertexBufferHandle"
		.mem   "const Memory *"
		.decl  "const VertexDecl &"
		.flags "uint16_t"

	func.setName { cname = "set_vertex_buffer_name" }
		"void"
		.handle "VertexBufferHandle"
		.name   "const char *"
		.len    "int32_t"

	func.destroy { cname = "destroy_vertex_buffer" }
		"void"
		.handle "VertexBufferHandle"

end

codegen.nameconversion(idl.types, idl.funcs)

--for typename, v in pairs(idl.types) do
--	print(typename, v.cname)
--end

for _, v in ipairs(idl.funcs) do
--	print(v.name, v.ret.fulltype, v.attribs.cname)
--	for i, arg in ipairs(v.args) do
--		print(i,arg.name, arg.fulltype, arg.ctype)
--	end
	print((codegen.genc99(v)))
end
