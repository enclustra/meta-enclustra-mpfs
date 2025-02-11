FILESEXTRAPATHS:prepend := "${THISDIR}/files/:"

SRC_URI:append:me-pe1-generic = " \
    file://enclustra_mercury_baseboard.dtsi \
    file://enclustra_mercury_mp1_fabric.dtsi \
    file://enclustra_mercury_mp1.dts \
    "

SRC_URI:append:me-pe3-generic = " \
    file://enclustra_mercury_baseboard.dtsi \
    file://enclustra_mercury_mp1_fabric.dtsi \
    file://enclustra_mercury_mp1.dts \
    "

SRC_URI:append:me-st1-generic = " \
    file://enclustra_mercury_baseboard.dtsi \
    file://enclustra_mercury_mp1_fabric.dtsi \
    file://enclustra_mercury_mp1.dts \
    "
