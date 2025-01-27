# Enclustra Linux Reference Design for Microchip Polarfire SoC

## Maintainer

Enclustra GmbH  [support@enclustra.com]

## License

See [License](meta-enclustra-mpfs/COPYING.MIT)

## Changelog

| Date       | Version | Comment                                                                         |
|------------|---------|---------------------------------------------------------------------------------|
| 07.10.2022 | 2021.11 | First version with meta-polarfire-soc-yocto-bsp 2021.11 used for MP1 validation |
| 24.10.2022 | 2022.09 | Update to meta-polarfire-soc-yocto-bsp 2022.09                                  |

## Description

This repository contains a Yocto layer to generate Linux reference designs for the [Enclustra Mercury+ MP1 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-mp1/).
The Yocto layer can be included into an own project or the provided [build.yml](build.yml) can be used to build a design using [kas](https://kas.readthedocs.io/en/latest/#) tool.
The reference design is based on [meta-polarfire-soc-yocto-bsp](https://github.com/polarfire-soc/meta-polarfire-soc-yocto-bsp) release 2022.09 that uses following versions.

- Yocto: honister
- U-Boot: 2022.01
- Linux:  kernel 5.15.68

## FPGA Reference Designs for Microchip Libero

The generated binaries are compatible with the FPGA and MSS configuration of following reference designs:

- [Mercury+ MP1 PE1 Reference Design](https://github.com/enclustra/Mercury_MP1_PE1_Reference_Design)
- [Mercury+ MP1 PE3 Reference Design](https://github.com/enclustra/Mercury_MP1_PE3_Reference_Design)
- [Mercury+ MP1 ST1 Reference Design](https://github.com/enclustra/Mercury_MP1_ST1_Reference_Design)

## Hart Software Services

The HSS software with support for Mercury+ MP1 can be found in following repository:

- [Hart Software Services](https://github.com/enclustra/hart-software-services)

## Host Requirements

### Host Operating System

This reference design was tested on following operating systems:

- Ubuntu 20.04

### Required Packages

Following packages are required for building this reference design on Ubuntu:

    gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev zstd liblz4-tool libyaml-dev libelf-dev python3-distutils

The packages can be installed with **sudo apt install \<package\>** command.
See [Yocto System Requirements](https://docs.yoctoproject.org/3.4.2/ref-manual/system-requirements.html?highlight=host) for more details about requirements for Linux distributions other than Ubuntu.

## Build

### Supported Machine Targets

The product model can be specified as target device (variable: **MACHINE**). Following product models are supported:

- me-mp1-250-si-d3en
- me-mp1-250-si-d3en-e1

### Supported Enclustra Base Boards

The Enclustra base board can be specified with **ENCLUSTRA_BASEBOARD** variable. Following base boards are supported:

- pe1 ([Mercury+ PE1](https://www.enclustra.com/en/products/base-boards/mercury-pe1-200-300-400))
- pe3 ([Mercury+ PE3](https://www.enclustra.com/en/products/base-boards/mercury-pe3))
- st1 ([Mercury+ ST1](https://www.enclustra.com/en/products/base-boards/mercury-st1))

### Accelerate Build

To reuse the downloaded files and built packages for further builds, the **DL_DIR** and **SSTATE_DIR** variable can be set to a local directory. If this project is built for the first time, these directories must be created manually. If the variables are not set, the default directories in the build directory are used.

As example:

    export SSTATE_DIR="${HOME}/Desktop/riscv-sstate-cache"
    export DL_DIR="${HOME}/Desktop/yocto-downloads"

### KAS

The recommended build flow is to use kas, which is a Python based tool that provides an easy mechanism to setup a bitbake project. The configuration file [build.yml](build.yml) provides all required settings. See [documentation](https://kas.readthedocs.io/en/latest/command-line.html) for more details.

#### Installation

    pip install kas
    export PATH=$PATH:${HOME}/.local/bin

#### Usage \#1

Use following command to build the target specified in the build.yml file (default = me-mp1-250-si-d3en). A base board can be specified optionally. If ENCLUSTRA_BASEBOARD variable is set, base board dependent devicetree settings are added to the kernel devicetree.

    export ENCLUSTRA_BASEBOARD=pe3
    kas build build.yml

#### Usage \#2

Use following command to specify the bitbake command to be executed. **MACHINE** and **ENCLUSTRA_BASEBOARD** variable can be overridden according to sections [Supported Machine Targets](#supported-machine-targets) and [Supported Enclustra Base Boards](#supported-enclustra-base-boards).

    kas shell build.yml -c 'MACHINE=me-mp1-250-si-d3en ENCLUSTRA_BASEBOARD=pe3 bitbake image-minimal-hwtest'

Note that the image [image-minimal-hwtest](meta-enclustra-mpfs/recipes-core/images/image-minimal-hwtest.bb) can be replaced by any available image recipe. Following are a few examples provided by openembedded-core layer:
- core-image-base
- core-image-minimal
- core-image-minimal-dev
- core-image-x11

#### Usage \#3

The tool kas can be used to checkout the repositories and setup the build directory. The build process can be started independently with bitbake as shown in following example.

    kas checkout kas-project.yml
    source openembedded-core/oe-init-build-env 
    export BB_ENV_EXTRAWHITE="ENCLUSTRA_BASEBOARD"
    MACHINE=me-mp1-250-si-d3en ENCLUSTRA_BASEBOARD=pe3 bitbake image-minimal-hwtest

## Deployment

The OpenEmbedded Image Creator (wic) creates a partitioned image file for SD card/eMMC. The partitions are configured in the OpenEmbedded kickstart file ([meta-enclustra-mpfs/wic/enclustra-mercury-mp1.wks](meta-enclustra-mpfs/wic/enclustra-mercury-mp1.wks)). The image file to be deployed on SD card/eMMC can be found in **build/tmp-glibc/deploy/images/\<MACHINE\>** directory, e.g. **image-minimal-hwtest-me-mp1-250-si-d3en.wic**.

To be able to boot Linux, the SoC must be programmed with the [bitstream](#fpga-reference-designs-for-microchip-libero) and [HSS](#hart-software-services).

### Creating a Bootable SD Card

Copy the image file to a SD card e.g.

    dd if=image-minimal-hwtest-me-mp1-250-si-d3en.wic of=<device> && sync

Note that the device of the SD card (\<device\>) needs to be replaced with the SD card device on your host (e.g. /dev/sdd).

### eMMC Memory

Connect the USB device port of the base board to a host PC and configure the DIP switches of the base board for USB device operation.
When the boot process is stopped in the HSS (by pressing any key), an USB service can be started by typing **usbdmsc**.
This service attaches the eMMC memory as a pen drive to the host PC and the wic image can be copied to the eMMC as described in section [Creating a Bootable SD Card](#Creating-a-Bootable-SD-Card).
No SD card must be inserted in the SD card slot of the base board. If a SD card is inserted, the pen drive shows the SD card and not the eMMC memory.

:warning: Make sure to disconnect the USB cable of the base board before booting Linux. Linux is configured to use USB in host mode by default.

## Login on Target

Login with **root** as user name, no password is set.

## Devicetree

Linux and U-Boot use the same devicetree source files to prevent from maintaining two separate devicetree sources.
This is achieved by linking the kernel devicetree sources to U-Boot in the meta-enclustra-mpfs layer.

Following list show all devicetree include files added by meta-enclustra-mpfs:

| File name                                                                                                                                | Description |
|------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [enclustra_mercury_mp1_common.dtsi](meta-enclustra-mpfs/recipes-kernel/linux/files/enclustra_mercury_mp1_common.dtsi)                    | Common definitions that are valid for all Mercury+ MP1 product models |
| [enclustra_mercury_mp1_fabric.dtsi](meta-enclustra-mpfs/recipes-kernel/linux/files/me-mp1-250-si-d3en/enclustra_mercury_mp1_fabric.dtsi) | Devicetree nodes in FPGA fabric |
| [enclustra_mercury_mp1.dts](meta-enclustra-mpfs/recipes-kernel/linux/files/me-mp1-250-si-d3en/enclustra_mercury_mp1.dts)                 | Top level devicetree. Contains nodes and properties that are specific to that product model as DDR4 memory size |
| [enclustra_mercury_pe1.dtsi](meta-enclustra-mpfs/recipes-kernel/linux/files/enclustra_mercury_pe1.dtsi)                                  | Mercury+ PE1 base board specific devicetree properties |
| [enclustra_mercury_pe3.dtsi](meta-enclustra-mpfs/recipes-kernel/linux/files/enclustra_mercury_pe3.dtsi)                                  | Mercury+ PE3 base board specific devicetree properties |
| [enclustra_mercury_st1.dtsi](meta-enclustra-mpfs/recipes-kernel/linux/files/enclustra_mercury_st1.dtsi)                                  | Mercury+ ST1 base board specific devicetree properties |

### Modification for eMMC boot

On the Mercury+ MP1 product series, the MSS MMC controller is connected through a multiplexer to a eMMC memory located on the module and to a SD card slot located on the base board. During the boot process, the HSS selects one of the two devices depending on if a SD card is inserted in the SD card slot. If a SD card is inserted, the system boots from SD card, otherwise it boots from eMMC.

The default devicetree works for both SD card and eMMC memory, but the eMMC performance is limited. The devicetree needs to be modified for full eMMC support (use of 8 data lanes instead of only 4) with the disadvantage that SD card is not supported anymore.

In file [meta-enclustra-mpfs/recipes-kernel/linux/files/enclustra_mercury_mp1_common.dtsi](meta-enclustra-mpfs/recipes-kernel/linux/files/enclustra_mercury_mp1_common.dtsi) in 'mmc' node, following settings needs to be removed or commented out:

	/* SD card */
	bus-width = <4>;
	no-1-8-v;
	cap-sd-highspeed;
	card-detect-delay = <200>;

And following settings need to be added or the existing comments removed:

	/* eMMC */
	bus-width = <8>;
	non-removable;
	cap-mmc-highspeed;
	no-1-8-v;

### Base Board Dependent Peripherals

If the **ENCLUSTRA_BASEBOARD** variable is set to an Enclustra Base Board, a devicetree include file is added for the Linux kernel which contains base-board specific configuration settings:
 
| Base board   | Value of variable<br>ENCLUSTRA_BASEBOARD | Included devicetree file                                                                                | Added peripherals |
|--------------|------------------------------------------|---------------------------------------------------------------------------------------------------------|-------------------|
| Mercury+ PE1 | pe1                                      | [enclustra_mercury_pe1.dtsi](meta-enclustra-mpfs/recipes-kernel/linux/files/enclustra_mercury_pe1.dtsi) | - 24AA128 I2C EEPROM<br>- LM96080 voltage/current monitor | 
| Mercury+ PE3 | pe3                                      | [enclustra_mercury_pe3.dtsi](meta-enclustra-mpfs/recipes-kernel/linux/files/enclustra_mercury_pe3.dtsi) | - 24AA128 I2C EEPROM<br>- LM96080 voltage/current monitor<br>- PCAl6416 I2C IO expander |
| Mercury+ ST1 | st1                                      | [enclustra_mercury_st1.dtsi](meta-enclustra-mpfs/recipes-kernel/linux/files/enclustra_mercury_st1.dtsi) |  |

## Patches

### U-Boot

Following U-Boot patches are added.

| Patch Name                                                                                                                                                                      | Description |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [0001-Enclustra-MAC-address-readout-from-EEPROM.patch](meta-enclustra-mpfs/recipes-bsp/u-boot/files/0001-Enclustra-MAC-address-readout-from-EEPROM.patch)                       | Add a feature to read and configure the MAC address from atsha204a EEPROM |
| [0002-Board-files-for-Mercury-MP1-added.patch](meta-enclustra-mpfs/recipes-bsp/u-boot/files/0002-Board-files-for-Mercury-MP1-added.patch)                                       | Add support for Mercury+ MP1 product series |
| [0003-Devicetree-for-Mercury-MP1-added.patch](meta-enclustra-mpfs/recipes-bsp/u-boot/files/0003-Devicetree-for-Mercury-MP1-added.patch)                                         | Add MP1 devicetree to Makefile |
| [0004-PolarFire-SoC-I2C-driver-modification-for-zero-sized.patch](meta-enclustra-mpfs/recipes-bsp/u-boot/files/0004-PolarFire-SoC-I2C-driver-modification-for-zero-sized.patch) | Remove check in Microchip I2C driver to allow wakeup of atsha204a by transmitting only 1 byte |
| [0005-Bugfix-for-atsha204a-driver.patch](meta-enclustra-mpfs/recipes-bsp/u-boot/files/0005-Bugfix-for-atsha204a-driver.patch)                                                   | Fix wakeup sequence in atsha204a driver |
| [0006-Use-only-high-memory-region.patch](meta-enclustra-mpfs/recipes-bsp/u-boot/files/0006-Use-only-high-memory-region.patch)                                                   | Modifications to allow booting from address > 4Gbyte |
| [0007-Rename-mpfs-devicetree.patch](meta-enclustra-mpfs/recipes-bsp/u-boot/files/0007-Rename-mpfs-devicetree.patch)                                                             | Rename microchip-mpfs.dtsi to mpfs.dtsi to be able to reuse the devicetree from Linux kernel |
| [0008-SI5338-configuration.patch](meta-enclustra-mpfs/recipes-bsp/u-boot/files/0008-SI5338-configuration.patch)                                                                 | Add configuration of SI5338 clock generator in U-Boot |

### Linux Kernel

Following Linux kernel patches are added.

| Patch Name                                                                                                                                                                        | Description |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [0001-Add-atsha204a-driver-with-support-to-read-OTP-region.patch](meta-enclustra-mpfs/recipes-kernel/linux/files/0001-Add-atsha204a-driver-with-support-to-read-OTP-region.patch) | Add driver to read serial number from EEPROM |
| [0002-Devicetree-for-Mercury-MP1-added.patch](meta-enclustra-mpfs/recipes-kernel/linux/files/0002-Devicetree-for-Mercury-MP1-added.patch)                                         | Add MP1 devicetree to Makefile |

## Additional Information

### Ethernet MAC address configuration

Each Enclustra module is delivered with two unique MAC addresses stored in the EEPROM. During the boot process, these MAC addresses are automatically read by U-Boot and configured to be used by U-Boot and Linux.

### Reading Serial Number of Module

The serial number of the module can be read by following command:

    cat /sys/bus/i2c/devices/1-0064/serial

The serial number is reported as follows:

    248173

### Read OTP region of EEPROM

The one time programmable region of the EEPROM contains the serial number, MAC address and information about the module. A detailed description can be found in the user manual of the module. The entire region can be read by following command:

    cat /sys/bus/i2c/devices/1-0064/otp

The 512 bits of the OTP region are reported as follows:

    00 03 C9 6D
    03 39 00 01
    00 88 51 23
    77 FF FF FF
    20 B0 F7 07
    92 DA FF FF
    FF FF FF FF
    FF FF FF FF
    FF FF FF FF
    FF FF FF FF
    FF FF FF FF
    FF FF FF FF
    FF FF FF FF
    FF FF FF FF
    FF FF FF FF
    FF FF FF FF

### Rootfs Partition Size

The size of the rootfs partition is set to 132 Mbyte by default. To change the partition size, the OpenEmbedded kickstart file [meta-enclustra-mpfs/wic/enclustra-mercury-mp1.wks](meta-enclustra-mpfs/wic/enclustra-mercury-mp1.wks) needs to be modified. The partition size is defined by **--fixed-size** parameter as shown below.

```
part / --source rootfs --ondisk mmcblk0 --fstype=ext4 --label root --align 4096 --fixed-size 131072K
```

### Configure SI5338 clock generator on Mercury+ PE1 and Mercury+ ST1 base board

The U-Boot patch [0008-SI5338-configuration.patch](meta-enclustra-mpfs/recipes-bsp/u-boot/files/0008-SI5338-configuration.patch) adds support to configure the clock generator device. To enable the configuration, follow the steps below:

1. Create a configuration with Skyworks [ClockBuilder Pro software](https://www.skyworksinc.com/Application-Pages/Clockbuilder-Pro-Software) and export the C code header file.
2. Copy the exported header file to **meta-enclustra-mpfs/recipe_bsp/u-boot/files/** directory and overwrite the example file [Si5338-RevB-Registers.h](meta-enclustra-mpfs/recipes-bsp/u-boot/files/Si5338-RevB-Registers.h)
3. Make following changes to file [meta-enclustra-mpfs/recipes-bsp/u-boot/files/enclustra_mercury_mp1_defconfig](meta-enclustra-mpfs/recipes-bsp/u-boot/files/enclustra_mercury_mp1_defconfig):

       CONFIG_SI5338_CONFIGURATION=y

## Known Issues:

#### Minimal I2C Frequency

The clock frequency of the I2C bus is derived from the MSS AHB/APB bus clock. This clock is set to 150MHz by default. Because the biggest possible divider value is 960, the slowest possible I2C frequency is 150MHz/960=156.25kHz. With this
156.25kHz I2C clock frequency, the wake-up pulse duration of the Atmel ATSHA204a device is violated (52us instead of 60us). Measurements has shown that the device wakes up reliable when the wake-up pulse is bigger than 30us.

#### Software Reboot in U-Boot

Rebooting the hardware in U-Boot by **reset** command is not supported.
