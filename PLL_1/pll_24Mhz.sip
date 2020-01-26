set_global_assignment -entity "pll_24Mhz" -library "lib_pll_24Mhz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_24Mhz" -library "lib_pll_24Mhz" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "pll_24Mhz" -library "lib_pll_24Mhz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_24Mhz" -name SPD_FILE [file join $::quartus(sip_path) "pll_24Mhz.spd"]

set_global_assignment -library "lib_pll_24Mhz" -name MISC_FILE [file join $::quartus(sip_path) "pll_24Mhz_sim/pll_24Mhz.vo"]
