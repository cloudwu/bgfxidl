/*
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

/*
 *
 * AUTO GENERATED! DO NOT EDIT!
 *
 */

$c99

/**/
BGFX_C_API bgfx_interface_vtbl_t* bgfx_get_interface(uint32_t _version)
{
	if (_version == BGFX_API_VERSION)
	{
		static bgfx_interface_vtbl_t s_bgfx_interface =
		{
			$interface_import
		};

		return &s_bgfx_interface;
	}

	return NULL;
}
