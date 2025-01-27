FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

ENCLUSTRA_UBOOT_PATCH_LIST = " \
    file://0001-Enclustra-MAC-address-readout-from-EEPROM.patch \
    file://0002-Board-files-for-Mercury-MP1-added.patch \
    file://0003-Devicetree-for-Mercury-MP1-added.patch \
    file://0004-PolarFire-SoC-I2C-driver-modification-for-zero-sized.patch \
    file://0005-Bugfix-for-atsha204a-driver.patch \
    file://0006-Use-only-high-memory-region.patch \
    file://0007-Rename-mpfs-devicetree.patch \
    file://0008-SI5338-configuration.patch \
    "

ENCLUSTRA_UBOOT_DTS_LIST = " \
    file://enclustra_mercury_mp1_common.dtsi \
    file://enclustra_mercury_mp1_common_fabric.dtsi \
    file://enclustra_mercury_mp1.dts \
    file://enclustra_mercury_mp1-u-boot.dtsi \
    file://enclustra_mercury_mp1_fabric.dtsi \
    "

ENCLUSTRA_UBOOT_COMMON_FILE_LIST = " \
    file://enclustra_mercury_mp1_defconfig \
    file://${UBOOT_ENV_SRC} \
    ${ENCLUSTRA_UBOOT_PATCH_LIST} \
    ${ENCLUSTRA_UBOOT_DTS_LIST} \
    file://Si5338-RevB-Registers.h \
    "

# Remove unwanted files added by meta-polarfire-soc-yocto-bsp
SRC_URI:remove:me-mp1-250-ees-d3e := " file://${UBOOT_ENV}.txt"
SRC_URI:remove:me-mp1-250-ees-d3e-e1 := " file://${UBOOT_ENV}.txt"
SRC_URI:remove:me-mp1-250-si-d3en := " file://${UBOOT_ENV}.txt"
SRC_URI:remove:me-mp1-250-si-d3en-e1 := " file://${UBOOT_ENV}.txt"
SRC_URI:remove:me-mp1-460-1si-d4e := " file://${UBOOT_ENV}.txt"
SRC_URI:remove:me-mp1-460-1si-d4e-e1 := " file://${UBOOT_ENV}.txt"

SRC_URI:append:me-mp1-250-ees-d3e := " ${ENCLUSTRA_UBOOT_COMMON_FILE_LIST}"
SRC_URI:append:me-mp1-250-ees-d3e-e1 := " ${ENCLUSTRA_UBOOT_COMMON_FILE_LIST}"
SRC_URI:append:me-mp1-250-si-d3en := " ${ENCLUSTRA_UBOOT_COMMON_FILE_LIST}"
SRC_URI:append:me-mp1-250-si-d3en-e1 := " ${ENCLUSTRA_UBOOT_COMMON_FILE_LIST}"
SRC_URI:append:me-mp1-460-1si-d4e := " ${ENCLUSTRA_UBOOT_COMMON_FILE_LIST}"
SRC_URI:append:me-mp1-460-1si-d4e-e1 := " ${ENCLUSTRA_UBOOT_COMMON_FILE_LIST}"

COMPATIBLE_MACHINE:append = " \
    |me-mp1-250-ees-d3e|me-mp1-250-si-d3en|me-mp1-460-1si-d4e| \
    |me-mp1-250-ees-d3e-e1|me-mp1-250-si-d3en-e1|me-mp1-460-1si-d4e-e1| \
    "

do_add_enclustra_devicetree() {
    if [ ${MACHINE} = "me-mp1-250-ees-d3e" ] || \
       [ ${MACHINE} = "me-mp1-250-ees-d3e-e1" ] || \
       [ ${MACHINE} = "me-mp1-250-si-d3en" ] || \
       [ ${MACHINE} = "me-mp1-250-si-d3en-e1" ] || \
       [ ${MACHINE} = "me-mp1-460-1si-d4e" ] || \
       [ ${MACHINE} = "me-mp1-460-1si-d4e-e1" ]; then
        cp ${WORKDIR}/enclustra_mercury_mp1_common.dtsi ${S}/arch/riscv/dts/
        cp ${WORKDIR}/enclustra_mercury_mp1_common_fabric.dtsi ${S}/arch/riscv/dts/
        cp ${WORKDIR}/enclustra_mercury_mp1.dts ${S}/arch/riscv/dts/
        cp ${WORKDIR}/enclustra_mercury_mp1-u-boot.dtsi ${S}/arch/riscv/dts/
        cp ${WORKDIR}/enclustra_mercury_mp1_fabric.dtsi ${S}/arch/riscv/dts/
        cp ${WORKDIR}/enclustra_mercury_mp1_defconfig ${S}/configs/
    fi
}

do_add_clockgen_config() {
    if test -f "${WORKDIR}/Si5338-RevB-Registers.h"; then
        mkdir -p ${S}/board/enclustra/mercury_mp1
        cp ${WORKDIR}/Si5338-RevB-Registers.h ${S}/board/enclustra/mercury_mp1/
    fi
}

addtask do_add_enclustra_devicetree after do_patch before do_configure
addtask do_add_clockgen_config after do_unpack before do_patch
