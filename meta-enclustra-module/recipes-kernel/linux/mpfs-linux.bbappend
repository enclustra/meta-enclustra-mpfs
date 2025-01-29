FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/patches:"

unset do_assemble_fitimage[depends]

ENCLUSTRA_KERNEL_PATCH_LIST = " \
    file://0001-Add-atsha204a-driver-with-support-to-read-OTP-region.patch \
    "

SRC_URI:append:me-mp1-generic := " \
    ${ENCLUSTRA_KERNEL_PATCH_LIST} \
    file://defconfig \
    "

COMPATIBLE_MACHINE:append = " |me-mp1-generic|"
