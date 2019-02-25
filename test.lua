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
	typedef "BackbufferRatio::Enum"
	typedef "OcclusionQueryResult::Enum"
	typedef "RendererType::Enum"
	typedef "TextureFormat::Enum"
	typedef "TopologyConvert::Enum"
	typedef "TopologySort::Enum"
	typedef "ViewMode::Enum"

	typedef "ReleaseFn"
	typedef "Caps"
	typedef "Init"
	typedef "InstanceDataBuffer"
	typedef "Memory"
	typedef "Stats"
	typedef "TransientIndexBuffer"
	typedef "TransientVertexBuffer"
	typedef "VertexDecl"
	typedef "ViewId"

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
		.max  "uint8_t"
		.enum "uint8_t" -- BUG: can't do :: in return types yet RendererType::Enum *"

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

	func.dbgTextPrintf
		"void"
		.x      "uint16_t"
		.y      "uint16_t"
		.attr   "uint8_t"
		.format "const char *"
-- missing vargs ...

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

	func.createDynamicVertexBuffer
		"DynamicVertexBufferHandle"
-- incomplete

	func.createDynamicVertexBuffer { cname = "create_dynamic_vertex_buffer_mem" }
		"DynamicVertexBufferHandle"
-- incomplete

	func.update { cname = "update_dynamic_vertex_buffer" }
		"void"
-- incomplete

	func.destroy { cname = "destroy_dynamic_vertex_buffer" }
		"void"
		.handle "DynamicVertexBufferHandle"

	func.getAvailTransientIndexBuffer
		"uint32_t"
		.num "uint32_t"

	func.getAvailTransientVertexBuffer
		"uint32_t"
		.num "uint32_t"
		.decl  "const VertexDecl &"

	func.getAvailInstanceDataBuffer
		"uint32_t"
		.num    "uint32_t"
		.stride "uint16_t"

	func.allocTransientIndexBuffer
		"void"
-- incomplete

	func.allocTransientVertexBuffer
		"void"
-- incomplete

	func.allocTransientBuffers
		"void"
-- incomplete

	func.allocInstanceDataBuffer
		"void"
-- incomplete

	func.createIndirectBuffer
		"IndirectBufferHandle"
-- incomplete

	func.destroy { cname = "destroy_indirect_buffer" }
		"void"
		.handle "IndirectBufferHandle"

	func.createShader
		"ShaderHandle"
-- incomplete

	func.getShaderUniforms
		"uint16_t"
-- incomplete

	func.setName { cname = "set_shader_name" }
		"void"
		.handle "ShaderHandle"
		.name   "const char *"
		.len    "int32_t"

	func.destroy { cname = "destroy_shader" }
		"void"
		.handle "ShaderHandle"

	func.createProgram
		"ProgramHandle"
-- incomplete

	func.createProgram { cname = "create_compute_program" }
		"ProgramHandle"
-- incomplete

	func.destroy { cname = "destroy_program" }
		"void"
		.handle "ProgramHandle"

	func.isTextureValid
		"bool"
-- incomplete

	func.calcTextureSize
		"void"
-- incomplete

	func.createTexture
		"TextureHandle"
-- incomplete

	func.createTexture2d
		"TextureHandle"
-- incomplete

	func.createTexture2dScaled
		"TextureHandle"
-- incomplete

	func.createTexture3d
		"TextureHandle"
-- incomplete

	func.createTextureCube
		"TextureHandle"
-- incomplete

	func.updateTexture2d
		"void"
-- incomplete

	func.updateTexture3d
		"void"
-- incomplete

	func.updateTextureCube
		"void"
-- incomplete

	func.readTexture
		"uint32_t"
-- incomplete

	func.setName { cname = "set_texture_name" }
		"void"
		.handle "TextureHandle"
		.name   "const char *"
		.len    "int32_t"

	func.getDirectAccessPtr
		"void *"
-- incomplete

	func.destroy { cname = "destroy_texture" }
		"void"

	func.createFrameBuffer
		"FrameBufferHandle"
-- incomplete

	func.createFrameBuffer { cname = "create_frame_buffer_scaled" }
		"FrameBufferHandle"
-- incomplete

	func.createFrameBuffer { cname = "create_frame_buffer_from_attachment" }
		"FrameBufferHandle"
-- incomplete

	func.createFrameBuffer { cname = "create_frame_buffer_from_nwh" }
		"FrameBufferHandle"
-- incomplete

	func.setName { cname = "set_frame_buffer_name" }
		"void"
		.handle "FrameBufferHandle"
		.name   "const char *"
		.len    "int32_t"

	func.getTexture
		"TextureHandle"
-- incomplete

	func.destroy { cname = "destroy_frame_buffer" }
		"void"
		.handle "FrameBufferHandle"

	func.createUniform
		"UniformHandle"
-- incomplete

	func.getUniformInfo
		"void"
-- incomplete

	func.destroy { cname = "destroy_uniform" }
		"void"

	func.createOcclusionQuery
		"OcclusionQueryHandle"
-- incomplete

	func.getResult
		"OcclusionQueryResult::Enum"
-- incomplete

	func.destroy { cname = "destroy_occlusion_query" }
		"void"
		.handle "OcclusionQueryHandle"

	func.setPaletteColor
		"void"
-- incomplete

	func.setViewName
		"void"
		.id   "ViewId"
		.name "const char *"

	func.setViewRect
		"void"
		.id     "ViewId"
		.x      "uint16_t"
		.y      "uint16_t"
		.width  "uint16_t"
		.height "uint16_t"

	func.setViewRect { cname = "set_view_rect_ratio" }
		"void"
		.id    "ViewId"
		.x     "uint16_t"
		.y     "uint16_t"
		.ratio "BackbufferRatio::Enum"

	func.setViewScissor
		"void"
		.id     "ViewId"
		.x      "uint16_t"
		.y      "uint16_t"
		.width  "uint16_t"
		.height "uint16_t"

	func.setViewClear
		"void"
		.id      "ViewId"
		.flags   "uint16_t"
		.rgba    "uint32_t"
		.depth   "float"
		.stencil "uint8_t"

	func.setViewClear { cname = "set_view_clear_mrt" }
		"void"
		.id      "ViewId"
		.flags   "uint16_t"
		.rgba    "uint32_t"
		.depth   "float"
		.stencil "uint8_t"
		.c0      "uint8_t"
		.c1      "uint8_t"
		.c2      "uint8_t"
		.c3      "uint8_t"
		.c4      "uint8_t"
		.c5      "uint8_t"
		.c6      "uint8_t"
		.c7      "uint8_t"

	func.setViewMode
		"void"
		.id   "ViewId"
		.mode "ViewMode::Enum"

	func.setViewFrameBuffer
		"void"
		.id     "ViewId"
		.handle "FrameBufferHandle"

	func.setViewTransform
		"void"
		.id   "ViewId"
		.view "const void *"
		.proj "const void *"

	func.setViewOrder
		"void"
		.id    "ViewId"
		.num   "uint16_t"
		.order "const ViewId *"

--[[
encoder_set_marker
encoder_set_state
encoder_set_condition
encoder_set_stencil
encoder_set_scissor
encoder_set_scissor_cached
encoder_set_transform
encoder_alloc_transform
encoder_set_transform_cached
encoder_set_uniform
encoder_set_index_buffer
encoder_set_dynamic_index_buffer
encoder_set_transient_index_buffer
encoder_set_vertex_buffer
encoder_set_dynamic_vertex_buffer
encoder_set_transient_vertex_buffer
encoder_set_vertex_count
encoder_set_instance_data_buffer
encoder_set_instance_data_from_vertex_buffer
encoder_set_instance_data_from_dynamic_vertex_buffer
encoder_set_instance_count
encoder_set_texture
encoder_touch
encoder_submit
encoder_submit_occlusion_query
encoder_submit_indirect
encoder_set_image
encoder_set_compute_index_buffer
encoder_set_compute_vertex_buffer
encoder_set_compute_dynamic_index_buffer
encoder_set_compute_dynamic_vertex_buffer
encoder_set_compute_indirect_buffer
encoder_dispatch
encoder_dispatch_indirect
encoder_discard
encoder_blit
--]]

	func.requestScreenShot
		"void"
		.handle   "FrameBufferHandle"
		.filePath "const char *"
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
