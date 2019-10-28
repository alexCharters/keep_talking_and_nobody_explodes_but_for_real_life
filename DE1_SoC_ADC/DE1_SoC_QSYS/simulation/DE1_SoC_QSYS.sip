set_global_assignment -entity "DE1_SoC_QSYS" -library "lib_DE1_SoC_QSYS" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "DE1_SoC_QSYS" -library "lib_DE1_SoC_QSYS" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "DE1_SoC_QSYS" -library "lib_DE1_SoC_QSYS" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_DE1_SoC_QSYS" -name SPD_FILE [file join $::quartus(sip_path) "../DE1_SoC_QSYS.spd"]
set_global_assignment -library "lib_DE1_SoC_QSYS" -name MISC_FILE [file join $::quartus(sip_path) "../../DE1_SoC_QSYS.qsys"]

set_global_assignment -library "lib_DE1_SoC_QSYS" -name MISC_FILE [file join $::quartus(sip_path) "DE1_SoC_QSYS.v"]
