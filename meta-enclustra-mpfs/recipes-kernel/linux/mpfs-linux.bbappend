FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

ENCLUSTRA_KERNEL_PATCH_LIST = " \
    file://0001-Add-atsha204a-driver-with-support-to-read-OTP-region.patch \
    "

ENCLUSTRA_KERNEL_COMMON_FILE_LIST = " \
    ${ENCLUSTRA_KERNEL_PATCH_LIST} \
    file://defconfig \
    "

SRC_URI:append:me-mp1-250-si-d3en = " ${ENCLUSTRA_KERNEL_COMMON_FILE_LIST}"
SRC_URI:append:me-mp1-250-si-d3en-e1 = " ${ENCLUSTRA_KERNEL_COMMON_FILE_LIST}"

COMPATIBLE_MACHINE:append = " \
    |me-mp1-250-si-d3en| \
    |me-mp1-250-si-d3en-e1| \
    "
