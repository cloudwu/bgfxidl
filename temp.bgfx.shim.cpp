/*
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

/*
 *
 * AUTO GENERATED! DO NOT EDIT!
 *
 */

#include <bgfx/bgfx.h>
#include <bgfx/c99/bgfx.h>

static bgfx_interface_vtbl_t* g_interface;

namespace bgfx
{
	static void* s_bgfx = NULL;

	bool init(const Init& _init)
	{
		s_bgfx = bx::dlopen("bgfx." BX_DL_EXT);

		if (NULL == s_bgfx)
		{
			return false;
		}

		PFN_BGFX_GET_INTERFACE get_interface = bx::dlsym(s_bgfx, "bgfx_get_interface");

		if (NULL == get_interface)
		{
			bx::dlclose(s_bgfx);
			return false;
		}

		g_interface = get_interface(BGFX_VERSION);

		if (NULL == g_interface)
		{
			bx::dlclose(s_bgfx);
			return false;
		}

		return true;
	}


$cpp_interface

} // namespace bgfx

$c99_interface
