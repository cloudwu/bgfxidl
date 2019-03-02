/*
 * Copyright 2011-2019 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx/blob/master/LICENSE
 */

/*
 *
 * AUTO GENERATED! DO NOT EDIT! ( source : $source )
 *
 */

#ifndef BGFX_H_HEADER_GUARD
#define BGFX_H_HEADER_GUARD

#include <stdarg.h> // va_list
#include <stdint.h> // uint32_t
#include <stdlib.h> // NULL

#include "defines.h"

#define BGFX_INVALID_HANDLE { bgfx::kInvalidHandle }

namespace bx { struct AllocatorI; }

/// BGFX
namespace bgfx
{

$handles

$enums

$funcptrs

$structs

$cppdecl

inline bool VertexDecl::has(Attrib::Enum _attrib) const { return UINT16_MAX != m_attributes[_attrib]; }

inline uint16_t VertexDecl::getOffset(Attrib::Enum _attrib) const { return m_offset[_attrib]; }

inline uint16_t VertexDecl::getStride() const { return m_stride; }

inline uint32_t VertexDecl::getSize(uint32_t _num) const { return _num*m_stride; }

} // namespace bgfx

#endif // BGFX_H_HEADER_GUARD
