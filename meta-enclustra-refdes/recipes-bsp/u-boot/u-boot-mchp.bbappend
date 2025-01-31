FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/patches:"

SRC_URI:append:me-mp1-generic := " \
    file://0008-SI5338-configuration.patch \
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

addtask do_add_clockgen_config after do_unpack before do_patch
