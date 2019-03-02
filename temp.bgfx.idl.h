/*
 * Copyright 2011-2019 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx/blob/master/LICENSE
 *
 * vim: set tabstop=4 expandtab:
 */

/*
 *
 * AUTO GENERATED! DO NOT EDIT!
 *
 */

#ifndef BGFX_C99_H_HEADER_GUARD
#define BGFX_C99_H_HEADER_GUARD

#include <stdarg.h>  // va_list
#include <stdbool.h> // bool
#include <stdint.h>  // uint32_t
#include <stdlib.h>  // size_t

#include <bx/platform.h>

#if !defined(BGFX_INVALID_HANDLE)
#   define BGFX_INVALID_HANDLE { UINT16_MAX }
#endif // !defined(BGFX_INVALID_HANDLE)

#ifndef BGFX_SHARED_LIB_BUILD
#    define BGFX_SHARED_LIB_BUILD 0
#endif // BGFX_SHARED_LIB_BUILD

#ifndef BGFX_SHARED_LIB_USE
#    define BGFX_SHARED_LIB_USE 0
#endif // BGFX_SHARED_LIB_USE

#if BX_PLATFORM_WINDOWS
#   define BGFX_SYMBOL_EXPORT __declspec(dllexport)
#   define BGFX_SYMBOL_IMPORT __declspec(dllimport)
#else
#   define BGFX_SYMBOL_EXPORT __attribute__((visibility("default")))
#   define BGFX_SYMBOL_IMPORT
#endif // BX_PLATFORM_WINDOWS

#if BGFX_SHARED_LIB_BUILD
#   define BGFX_SHARED_LIB_API BGFX_SYMBOL_EXPORT
#elif BGFX_SHARED_LIB_USE
#   define BGFX_SHARED_LIB_API BGFX_SYMBOL_IMPORT
#else
#   define BGFX_SHARED_LIB_API
#endif // BGFX_SHARED_LIB_*

#if defined(__cplusplus)
#   define BGFX_C_API extern "C" BGFX_SHARED_LIB_API
#else
#   define BGFX_C_API BGFX_SHARED_LIB_API
#endif // defined(__cplusplus)

#include "../defines.h"

$cenums
$chandles

/**/
typedef void (*bgfx_release_fn_t)(void* _ptr, void* _userData);

$cstructs
$c99decl
/**/
typedef struct bgfx_interface_vtbl
{
	$interface_struct
} bgfx_interface_vtbl_t;

/**/
typedef bgfx_interface_vtbl_t* (*PFN_BGFX_GET_INTERFACE)(uint32_t _version);

/**/
BGFX_C_API bgfx_interface_vtbl_t* bgfx_get_interface(uint32_t _version);

#endif // BGFX_C99_H_HEADER_GUARD
