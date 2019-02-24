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
	typedef "va_list"

	typedef "Attrib::Enum"
	typedef "ReleaseFn"
	typedef "RendererType::Enum"
	typedef "TextureFormat::Enum"
	typedef "TopologyConvert::Enum"
	typedef "TopologySort::Enum"
	typedef "Caps"
	typedef "Init"
	typedef "Memory"
	typedef "Stats"
	typedef "VertexDecl"

	typedef.DynamicIndexBufferHandle  { "handle" }
	typedef.DynamicVertexBufferHandle { "handle" }
	typedef.FrameBufferHandle         { "handle" }
	typedef.IndexBufferHandle         { "handle" }
	typedef.IndirectBufferHandle      { "handle" }
	typedef.OcclusionQueryHandle      { "handle" }
	typedef.ProgramHandle             { "handle" }
	typedef.ShaderHandle              { "handle" }
	typedef.TextureHandle             { "handle" }
	typedef.UniformHandle             { "handle" }
	typedef.VertexBufferHandle        { "handle" }
	typedef.VertexDeclHandle          { "handle" }

	func.vertexDeclBegin
		"void"
-- incomplete

	func.vertexDeclAdd
		"void"
-- incomplete

	func.vertexDeclDecode
		"void"
-- incomplete

	func.vertexDeclHas
		"bool"
-- incomplete

	func.vertexDeclSkip
		"void"
-- incomplete

	func.vertexDeclEnd
		"void"
-- incomplete

	func.vertexPack
		"void"
		.input           "const float *"
		.inputNormalized "bool"
		.attr            "Attrib::Enum"
		.decl            "const VertexDecl &"
		.data            "void *"
		.index           "uint32_t"

	func.vertexUnpack
		"void"
		.output          "const float *"
		.inputNormalized "bool"
		.attr            "Attrib::Enum"
		.decl            "const VertexDecl &"
		.data            "void *"
		.index           "uint32_t"

	func.vertexConvert
		"void"
		.dstDecl "const VertexDecl &"
		.dstData "void *"
		.srcDecl "const VertexDecl &"
		.srcData "const void *"
		.num     "uint32_t"

	func.weldVertices
		"uint16_t"
		.output  "uint16_t *"
		.decl    "const VertexDecl &"
		.data    "const void *"
		.num     "uint16_t"
		.epsilon "float"

	func.topologyConvert
		"uint32_t"
		.conversion "TopologyConvert::Enum"
		.dst        "void *"
		.dstSize    "uint32_t"
		.indices    "const void *"
		.numIndices "uint32_t"
		.index32    "bool"

	func.topologySortTriList
		"void"
		.sort       "TopologySort::Enum"
		.dst        "void *"
		.dstSize    "uint32_t"
		.dir        "const float *"
		.pos        "const float *"
		.vertices   "const void *"
		.stride     "uint32_t"
		.indices    "const void *"
		.numIndices "uint32_t"
		.index32    "bool"

	func.getSupportedRenderers
		"uint8_t"

	func.getRendererName
		"const char *"
		.type "RendererType::Enum"

	func.initCtor
		"void"
		.init "Init *"

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

	func.makeRef { cname = "make_ref_release" }
		"const Memory *"
		.data      "const void *"
		.size      "uint32_t"
		.releaseFn "ReleaseFn"
		.userData  "void *"

	func.setDebug
		"void"
		.debug "uint32_t"

	func.dbgTextClear
		"void"
		.attr  "uint8_t"
		.small "bool"

	func.dbgTextPrintf { vararg = "dbgTextPrintfVargs" }
		"void"
		._x "uint16_t"
		._y "uint16_t"
		._attr "uint8_t"
		._format "const char *"

	func.dbgTextPrintfVargs
		"void"
		.x       "uint16_t"
		.y       "uint16_t"
		.attr    "uint8_t"
		.format  "const char *"
		.argList "va_list"

	func.dbgTextImage
		"void"
		.x       "uint16_t"
		.y       "uint16_t"
		.width   "uint16_t"
		.height  "uint16_t"
		.data    "const void *"
		.pitch   "uint16_t"

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

	func.createDynamicIndexBuffer
		"DynamicIndexBufferHandle"
		.num   "uint32_t"
		.flags "uint16_t"

	func.createDynamicIndexBuffer { cname = "create_dynamic_index_buffer_mem" }
		"DynamicIndexBufferHandle"
		.mem   "const Memory *"
		.flags "uint16_t"

	func.update { cname = "update_dynamic_index_buffer" }
		"void"
		.handle     "DynamicIndexBufferHandle"
		.startIndex "uint32_t"
		.mem        "const Memory *"

	func.destroy { cname = "destroy_dynamic_index_buffer" }
		"void"
		.handle "DynamicIndexBufferHandle"
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
