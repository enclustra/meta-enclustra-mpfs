FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/patches:${THISDIR}/devicetree:"

SRC_URI:append:me-pe1-generic = " \
    file://enclustra_mercury_baseboard.dtsi \
    file://enclustra_mercury_mp1.dts \
    "

SRC_URI:append:me-pe3-generic = " \
    file://enclustra_mercury_baseboard.dtsi \
    file://enclustra_mercury_mp1.dts \
    "

SRC_URI:append:me-st1-generic = " \
    file://enclustra_mercury_baseboard.dtsi \
    file://enclustra_mercury_mp1.dts \
    "

SRC_URI:append:me-mp1-generic := " \
    file://0007-SI5338-configuration.patch \
    file://Si5338-RevB-Registers.h \
    file://clockgen.cfg \
    "

COMPATIBLE_MACHINE:append = " |me-mp1-generic|"

do_add_clockgen_config() {
}

do_add_clockgen_config:append:me-mp1-generic() {
    if test -f "${WORKDIR}/Si5338-RevB-Registers.h"; then
        mkdir -p ${S}/board/enclustra/mercury_mp1
        cp ${WORKDIR}/Si5338-RevB-Registers.h ${S}/board/enclustra/mercury_mp1/
    fi
}

do_add_enclustra_devicetree() {
}

do_add_enclustra_devicetree:append:me-pe1-generic() {
    cp ${WORKDIR}/enclustra_mercury_baseboard.dtsi ${S}/arch/riscv/dts/
}

do_add_enclustra_devicetree:append:me-pe3-generic() {
    cp ${WORKDIR}/enclustra_mercury_baseboard.dtsi ${S}/arch/riscv/dts/
}

do_add_enclustra_devicetree:append:me-st1-generic() {
    cp ${WORKDIR}/enclustra_mercury_baseboard.dtsi ${S}/arch/riscv/dts/
}

addtask do_add_clockgen_config after do_unpack before do_patch
addtask do_add_enclustra_devicetree after do_patch before do_configure
