SUMMARY = "Provides devicetree for Linux kernel"
LICENSE = "MIT & GPL-2.0-only"

inherit devicetree

PROVIDES = "virtual/dtb"

COMPATIBLE_MACHINE:append = " \
    |me-mp1-250-si-d3en| \
    |me-mp1-250-si-d3en-e1| \
    "

ENCLUSTRA_KERNEL_DTS_LIST = " \
    file://enclustra_mercury_mp1.dts \
    file://enclustra_mercury_mp1_common.dtsi \
    file://enclustra_mercury_mp1_common_fabric.dtsi \
    file://enclustra_mercury_mp1_fabric.dtsi \
    file://enclustra_mercury_pe1.dtsi \
    file://enclustra_mercury_pe3.dtsi \
    file://enclustra_mercury_st1.dtsi \
    "

SRC_URI:append:me-mp1-250-si-d3en = " ${ENCLUSTRA_KERNEL_DTS_LIST}"
SRC_URI:append:me-mp1-250-si-d3en-e1 = " ${ENCLUSTRA_KERNEL_DTS_LIST}"

do_configure[depends] += "virtual/kernel:do_configure"

do_add_enclustra_devicetree() {
    if [ ${MACHINE} = "me-mp1-250-si-d3en" ] || \
       [ ${MACHINE} = "me-mp1-250-si-d3en-e1" ]; then

        if [ ${ENCLUSTRA_BASEBOARD} = "pe1" ]; then
            echo "#include \"enclustra_mercury_pe1.dtsi\"" \
                >> ${WORKDIR}/enclustra_mercury_mp1.dts
            cp ${WORKDIR}/enclustra_mercury_pe1.dtsi ${S}/arch/riscv/boot/dts/microchip/
        fi

        if [ ${ENCLUSTRA_BASEBOARD} = "pe3" ]; then
            echo "#include \"enclustra_mercury_pe3.dtsi\"" \
                >> ${WORKDIR}/enclustra_mercury_mp1.dts
            cp ${WORKDIR}/enclustra_mercury_pe3.dtsi ${S}/arch/riscv/boot/dts/microchip/
        fi

        if [ ${ENCLUSTRA_BASEBOARD} = "st1" ]; then
            echo "#include \"enclustra_mercury_st1.dtsi\"" \
                >> ${WORKDIR}/enclustra_mercury_mp1.dts
            cp ${WORKDIR}/enclustra_mercury_st1.dtsi ${S}/arch/riscv/boot/dts/microchip/
        fi

    fi
}

addtask do_add_enclustra_devicetree after do_patch before do_configure
