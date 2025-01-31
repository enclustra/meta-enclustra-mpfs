FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/patches:${THISDIR}/devicetree:"

ENCLUSTRA_UBOOT_PATCH_LIST = " \
    file://0001-Enclustra-MAC-address-readout-from-EEPROM.patch \
    file://0002-Board-files-for-Mercury-MP1-added.patch \
    file://0003-Devicetree-for-Mercury-MP1-added.patch \
    file://0004-PolarFire-SoC-I2C-driver-modification-for-zero-sized.patch \
    file://0005-Bugfix-for-atsha204a-driver.patch \
    file://0006-Use-only-high-memory-region.patch \
    file://0007-Rename-mpfs-devicetree.patch \
    "

ENCLUSTRA_UBOOT_DTS_LIST = " \
    file://enclustra_mercury_mp1_common.dtsi \
    file://enclustra_mercury_mp1_common_fabric.dtsi \
    file://enclustra_mercury_mp1.dts \
    file://enclustra_mercury_mp1.dtsi \
    file://enclustra_mercury_mp1-u-boot.dtsi \
    file://enclustra_mercury_mp1_fabric.dtsi \
    "

SRC_URI:append:me-mp1-generic := " \
    file://enclustra_mercury_mp1_defconfig \
    file://${UBOOT_ENV_SRC} \
    ${ENCLUSTRA_UBOOT_PATCH_LIST} \
    ${ENCLUSTRA_UBOOT_DTS_LIST} \
    "

COMPATIBLE_MACHINE:append = " |me-mp1-generic|"

do_add_enclustra_devicetree() {
}

do_add_enclustra_devicetree:append:me-mp1-generic() {
    cp ${WORKDIR}/enclustra_mercury_mp1_common.dtsi ${S}/arch/riscv/dts/
    cp ${WORKDIR}/enclustra_mercury_mp1_common_fabric.dtsi ${S}/arch/riscv/dts/
    cp ${WORKDIR}/enclustra_mercury_mp1.dts ${S}/arch/riscv/dts/
    cp ${WORKDIR}/enclustra_mercury_mp1.dtsi ${S}/arch/riscv/dts/
    cp ${WORKDIR}/enclustra_mercury_mp1-u-boot.dtsi ${S}/arch/riscv/dts/
    cp ${WORKDIR}/enclustra_mercury_mp1_fabric.dtsi ${S}/arch/riscv/dts/
}

do_add_enclustra_config() {
}

do_add_enclustra_config:append:me-mp1-generic() {
    cp ${WORKDIR}/enclustra_mercury_mp1_defconfig ${S}/configs/
}

addtask do_add_enclustra_devicetree after do_patch before do_configure
addtask do_add_enclustra_config after do_patch before do_configure
