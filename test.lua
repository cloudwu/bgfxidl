local idl = require "idl"
local codegen = require "codegen"

do local _ENV = idl
	typedef "void"
	typedef "uint16_t"
	typedef "Memory"
	typedef.VertexDecl "bgfx_vertex_decl_t"
	typedef.VertexBufferHandle { "handle" }

	func.createVertexBuffer -- { cname = "bgfx_create_vertex_buffer" } 
		"VertexBufferHandle"  -- return type
		._mem "const Memory *"  -- args
		._decl "const VertexDecl &"
		._flags "uint16_t"

	func.destory { cname = "bgfx_destroy_vertex_buffer" }
		"void"
		._handle "VertexBufferHandle"
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