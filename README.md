An IDL for bgfx code generation
====

See https://github.com/cloudwu/bgfxidl/issues/9

Use `lua bgfx-idl.lua .` to generate bgfx IDL in current dir.

```lua
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
```

Generate C99 APIs :

```cpp
BGFX_C_API bgfx_vertex_buffer_handle_t bgfx_create_vertex_buffer(const bgfx_memory_t * _mem, const bgfx_vertex_decl_t * _decl, uint16_t _flags)
{
        const bgfx::VertexDecl & decl = *(const bgfx::VertexDecl *)_decl;
        union { bgfx_vertex_buffer_handle_t c; bgfx::VertexBufferHandle cpp; } handle_ret;
        handle_ret.cpp = bgfx::createVertexBuffer((const bgfx::Memory *)_mem, decl, _flags);
        return handle_ret.c;
}

BGFX_C_API void bgfx_destroy_vertex_buffer(bgfx_vertex_buffer_handle_t _handle)
{
        union { bgfx_vertex_buffer_handle_t c; bgfx::VertexBufferHandle cpp; } handle = { _handle };
        bgfx::destory(handle.cpp);
}

```

License
=======

The same with bgfx :

https://github.com/bkaradzic/bgfx/blob/master/LICENSE
