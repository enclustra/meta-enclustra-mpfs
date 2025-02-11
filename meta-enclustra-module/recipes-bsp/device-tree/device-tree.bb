SUMMARY = "Provides devicetree for Linux kernel"
LICENSE = "MIT & GPL-2.0-only"

inherit devicetree

PROVIDES = "virtual/dtb"

COMPATIBLE_MACHINE:append = " |me-mp1-generic|"

SRC_URI:append:me-mp1-generic = " \
    file://enclustra_mercury_mp1.dts \
    file://enclustra_mercury_mp1.dtsi \
    file://enclustra_mercury_mp1_common.dtsi \
    file://enclustra_mercury_mp1_common_fabric.dtsi \
    "

do_configure[depends] += "virtual/kernel:do_configure"
