FILESEXTRAPATHS:prepend := "${THISDIR}/files/:"

SRC_URI:append:me-pe1-generic = " file://enclustra_mercury_baseboard.dtsi"
SRC_URI:append:me-pe3-generic = " file://enclustra_mercury_baseboard.dtsi"
SRC_URI:append:me-st1-generic = " file://enclustra_mercury_baseboard.dtsi"
SRC_URI:append:me-mp1-generic = " file://enclustra_mercury_mp1.dts"
