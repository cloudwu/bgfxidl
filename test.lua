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

	typedef "Attachment"
	typedef "Caps"
	typedef "Encoder"
	typedef "Init"
	typedef "InstanceDataBuffer"
	typedef "Memory"
	typedef "ReleaseFn"
	typedef "Stats"
	typedef "TextureInfo"
	typedef "TransientIndexBuffer"
	typedef "TransientVertexBuffer"
	typedef "UniformInfo"
	typedef "VertexDecl"
	typedef "ViewId"

	typedef.Attrib               { enum }
	typedef.AttribType           { enum }
	typedef.BackbufferRatio      { enum }
	typedef.OcclusionQueryResult { enum }
	typedef.RendererType         { enum }
	typedef.TextureFormat        { enum }
	typedef.TopologyConvert      { enum }
	typedef.TopologySort         { enum }
	typedef.UniformType          { enum }
	typedef.ViewMode             { enum }

	typedef.DynamicIndexBufferHandle  { handle }
	typedef.DynamicVertexBufferHandle { handle }
	typedef.FrameBufferHandle         { handle }
	typedef.IndexBufferHandle         { handle }
	typedef.IndirectBufferHandle      { handle }
	typedef.OcclusionQueryHandle      { handle }
	typedef.ProgramHandle             { handle }
	typedef.ShaderHandle              { handle }
	typedef.TextureHandle             { handle }
	typedef.UniformHandle             { handle }
	typedef.VertexBufferHandle        { handle }
	typedef.VertexDeclHandle          { handle }

	func.VertexDecl.begin
		"void"
		.renderer        "RendererType::Enum"

	func.VertexDecl.add
		"void"
		.attrib          "Attrib::Enum"
		.num             "uint8_t"
		.type            "AttribType::Enum"
		.normalized      "bool"
		.asInt           "bool"

	func.VertexDecl.decode { const }
		"void"
		.attrib          "Attrib::Enum"
		.num             "uint8_t &"          { out }
		.type            "AttribType::Enum &" { out }
		.normalized      "bool &"             { out }
		.asInt           "bool &"             { out }

	func.VertexDecl.has { const }
		"bool"
		.attrib          "Attrib::Enum"

	func.VertexDecl.skip
		"void"
		.num             "uint8_t"

	-- Notice: `end` is a keyword in lua
	func.VertexDecl["end"]
		"void"

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
		.enum "RendererType::Enum *"

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

	func.createDynamicVertexBuffer
		"DynamicVertexBufferHandle"
		.num   "uint32_t"
		.decl  "const VertexDecl &"
		.flags "uint16_t"

	func.createDynamicVertexBuffer { cname = "create_dynamic_vertex_buffer_mem" }
		"DynamicVertexBufferHandle"
		.mem   "const Memory *"
		.decl  "const VertexDecl &"
		.flags "uint16_t"

	func.update { cname = "update_dynamic_vertex_buffer" }
		"void"
		.handle      "DynamicVertexBufferHandle"
		.startVertex "uint32_t"
		.mem         "const Memory *"

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
		.tib "TransientIndexBuffer *"
		.num "uint32_t"

	func.allocTransientVertexBuffer
		"void"
		.tvb  "TransientVertexBuffer *"
		.num  "uint32_t"
		.decl "const VertexDecl &"

	func.allocTransientBuffers
		"void"
		.tvb         "TransientVertexBuffer *"
		.decl        "const VertexDecl &"
		.numVertices "uint32_t"
		.tib         "TransientIndexBuffer *"
		.numIndices  "uint32_t"

	func.allocInstanceDataBuffer
		"void"
		.num    "uint32_t"
		.stride "uint16_t"

	func.createIndirectBuffer
		"IndirectBufferHandle"
		.num "uint32_t"

	func.destroy { cname = "destroy_indirect_buffer" }
		"void"
		.handle "IndirectBufferHandle"

	func.createShader
		"ShaderHandle"
		.mem "const Memory *"

	func.getShaderUniforms
		"uint16_t"
		.handle   "ShaderHandle"
		.uniforms "UniformHandle *"
		.max      "uint16_t"

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
		.vsh "ShaderHandle"
		.fsh "ShaderHandle"
		.destroyShaders "bool"

	func.createProgram { cname = "create_compute_program" }
		"ProgramHandle"
		.csh "ShaderHandle"
		.destroyShaders "bool"

	func.destroy { cname = "destroy_program" }
		"void"
		.handle "ProgramHandle"

	func.isTextureValid
		"bool"
		.depth     "uint16_t"
		.cubeMap   "bool"
		.numLayers "uint16_t"
		.format    "TextureFormat::Enum"
		.flags     "uint64_t"

	func.calcTextureSize
		"void"
		.info      "TextureInfo"
		.width     "uint16_t"
		.height    "uint16_t"
		.depth     "uint16_t"
		.cubeMap   "bool"
		.hasMips   "bool"
		.numLayers "uint16_t"
		.format    "TextureFormat::Enum"

	func.createTexture
		"TextureHandle"
		.mem   "const Memory *"
		.flags "uint64_t"
		.skip  "uint8_t"
		.info  "TextureInfo"

	func.createTexture2D
		"TextureHandle"
		.width     "uint16_t"
		.height    "uint16_t"
		.hasMips   "bool"
		.numLayers "uint16_t"
		.format    "TextureFormat::Enum"
		.flags     "uint64_t"
		.mem       "const Memory *"

	func.createTexture2D { cname = "create_texture_2d_scaled" }
		"TextureHandle"
		.ratio     "BackbufferRatio::Enum"
		.hasMips   "bool"
		.numLayers "uint16_t"
		.format    "TextureFormat::Enum"
		.flags     "uint64_t"
		.mem       "const Memory *"

	func.createTexture3D
		"TextureHandle"
		.width     "uint16_t"
		.height    "uint16_t"
		.depth     "uint16_t"
		.hasMips   "bool"
		.format    "TextureFormat::Enum"
		.flags     "uint64_t"
		.mem       "const Memory *"

	func.createTextureCube
		"TextureHandle"
		.size      "uint16_t"
		.hasMips   "bool"
		.numLayers "uint16_t"
		.format    "TextureFormat::Enum"
		.flags     "uint64_t"
		.mem       "const Memory *"

	func.updateTexture2D
		"void"
		.handle "TextureHandle"
		.layer  "uint16_t"
		.mip    "uint16_t"
		.x      "uint16_t"
		.y      "uint16_t"
		.width  "uint16_t"
		.height "uint16_t"
		.mem    "const Memory *"
		.pitch  "uint16_t"

	func.updateTexture3D
		"void"
		.handle "TextureHandle"
		.mip    "uint16_t"
		.x      "uint16_t"
		.y      "uint16_t"
		.z      "uint16_t"
		.width  "uint16_t"
		.height "uint16_t"
		.depth  "uint16_t"
		.mem    "const Memory *"

	func.updateTextureCube
		"void"
		.handle "TextureHandle"
		.layer  "uint16_t"
		.side   "uint16_t"
		.mip    "uint16_t"
		.x      "uint16_t"
		.y      "uint16_t"
		.width  "uint16_t"
		.height "uint16_t"
		.mem    "const Memory *"
		.pitch  "uint16_t"

	func.readTexture
		"uint32_t"
		.handle "TextureHandle"
		.data   "void *"
		.mip    "uint8_t"

	func.setName { cname = "set_texture_name" }
		"void"
		.handle "TextureHandle"
		.name   "const char *"
		.len    "int32_t"

	func.getDirectAccessPtr
		"void *"
		.handle "TextureHandle"

	func.destroy { cname = "destroy_texture" }
		"void"
		.handle "TextureHandle"

	func.createFrameBuffer
		"FrameBufferHandle"
		.width        "uint16_t"
		.height       "uint16_t"
		.format       "TextureFormat::Enum"
		.textureFlags "uint64_t"

	func.createFrameBuffer { cname = "create_frame_buffer_scaled" }
		"FrameBufferHandle"
		.ratio "BackbufferRatio::Enum"
		.format       "TextureFormat::Enum"
		.textureFlags "uint64_t"

	func.createFrameBuffer { cname = "create_frame_buffer_from_handles" }
		"FrameBufferHandle"
		.num            "uint8_t"
		.handles        "const TextureHandle *"
		.destroyTexture "bool"

	func.createFrameBuffer { cname = "create_frame_buffer_from_attachment" }
		"FrameBufferHandle"
		.num            "uint8_t"
		.handles        "const Attachment *"
		.destroyTexture "bool"

	func.createFrameBuffer { cname = "create_frame_buffer_from_nwh" }
		"FrameBufferHandle"
		.nwh         "void *"
		.width       "uint16_t"
		.height      "uint16_t"
		.format      "TextureFormat::Enum"
		.depthFormat "TextureFormat::Enum"

	func.setName { cname = "set_frame_buffer_name" }
		"void"
		.handle "FrameBufferHandle"
		.name   "const char *"
		.len    "int32_t"

	func.getTexture
		"TextureHandle"
		.handle     "FrameBufferHandle"
		.attachment "uint8_t"

	func.destroy { cname = "destroy_frame_buffer" }
		"void"
		.handle "FrameBufferHandle"

	func.createUniform
		"UniformHandle"
		.name "const char *"
		.type "UniformType::Enum"
		.num  "uint16_t"

	func.getUniformInfo
		"void"
		.handle "UniformHandle"
		.info   "UniformInfo *"

	func.destroy { cname = "destroy_uniform" }
		"void"
		.handle "UniformHandle"

	func.createOcclusionQuery
		"OcclusionQueryHandle"

	func.getResult
		"OcclusionQueryResult::Enum"
		.handle "OcclusionQueryHandle"
		.result "int32_t *"

	func.destroy { cname = "destroy_occlusion_query" }
		"void"
		.handle "OcclusionQueryHandle"

	func.setPaletteColor
		"void"
		.index "uint8_t"
		.rgba  "uint32_t"

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

	func.begin { cname = "encoder_begin" }
		"Encoder *"
		.forThread "bool"

	func["end"] { cname = "encoder_end" }
		"void"
		.encoder "Encoder *"

	func.setMarker { class = "Encoder" , cname = "encoder_set_marker" }
		"void"
		.marker "const char *"

	func.setState  { class = "Encoder" , cname = "encoder_set_state" }
		"void"
		.state "uint64_t"
		.rgba  "uint32_t"

--[[
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
