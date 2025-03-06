# Enclustra Linux Reference Design for Microchip Polarfire SoC

## Maintainer

Enclustra GmbH  [support@enclustra.com]

## License

See [License](meta-enclustra-module/COPYING.MIT)

## Changelog

| Date       | Version | Comment                                                                         |
|------------|---------|---------------------------------------------------------------------------------|
| 06.03.2025 | 2024.09 | - Update to meta-polarfire-soc-yocto-bsp 2024.09 <br> - DDR4 memory layout changed <br> - Reset in U-Boot fixed <br> - FPGA SPI flash is now accessible in Linux <br> - Support for me-mp1-460-1si-d4e and me-mp1-250-ees-d3e removed <br> - Single Yocto layer split into module and reference design layers <br> - I2C driver enabled for PL I2C in ST1 and PE3 reference designs <br> - GPIO driver enabled for all GPIOs in reference design |
| 24.10.2022 | 2022.09 | - Update to meta-polarfire-soc-yocto-bsp 2022.09 - SI5338 configuratiton added in U-Boot <br> - MSS QSPI flash is now accessible in Linux |
| 07.10.2022 | 2021.11 | - First version with meta-polarfire-soc-yocto-bsp 2021.11 used for MP1 validation |

## Description

This repository contains Yocto layers to generate Linux reference designs for the [Enclustra Mercury+ MP1 product series](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-mp1/).
The Yocto layers can be included into own projects or the provided file [build.yml](build.yml) can be used to build a design using [kas](https://kas.readthedocs.io/en/latest/#) tool.
The reference design is based on [meta-polarfire-soc-yocto-bsp](https://github.com/polarfire-soc/meta-polarfire-soc-yocto-bsp) release 2024.09 that uses following versions.

- Yocto: kirkstone
- U-Boot: 2023.07
- Linux:  kernel 6.6.51

## FPGA Reference Designs for Microchip Libero

The generated binaries are compatible with release 2024.2_v1.1.0 of the FPGA and MSS configuration of following reference designs:

- [Mercury+ MP1 PE1 Reference Design](https://github.com/enclustra/Mercury_MP1_PE1_Reference_Design)
- [Mercury+ MP1 PE3 Reference Design](https://github.com/enclustra/Mercury_MP1_PE3_Reference_Design)
- [Mercury+ MP1 ST1 Reference Design](https://github.com/enclustra/Mercury_MP1_ST1_Reference_Design)

## Hart Software Services

The HSS software with support for Mercury+ MP1 can be found in following repository:

- [Hart Software Services](https://github.com/enclustra/hart-software-services)

Make sure to use branch 2024.09 in combination with this release.

## Host Requirements

### Host Operating System

This reference design was tested on following operating systems:

- Ubuntu 22.04

### Required Packages

Following packages are required for building this reference design on Ubuntu:

    build-essential chrpath cpio debianutils diffstat file gawk gcc git iputils-ping libacl1 liblz4-tool locales python3 python3-git python3-jinja2 python3-pexpect python3-pip python3-subunit socat texinfo unzip wget xz-utils zstd

The packages can be installed with **sudo apt install \<package\>** command.
See [Yocto System Requirements](https://docs.yoctoproject.org/kirkstone/ref-manual/system-requirements.html#required-packages-for-the-build-host) for more details about requirements for Linux distributions other than Ubuntu.

## Build

### Supported Machine Targets

The product model of the module and base board can be specified as target device (variable: **MACHINE**). Following targets are supported:

- refdes-me-mp1-250-si-d3en-e1-pe1
- refdes-me-mp1-250-si-d3en-e1-pe3
- refdes-me-mp1-250-si-d3en-e1-st1
- refdes-me-mp1-250-si-d3en-pe1
- refdes-me-mp1-250-si-d3en-pe3
- refdes-me-mp1-250-si-d3en-st1

### Accelerate Build

To reuse the downloaded files and built packages for further builds, the **DL_DIR** and **SSTATE_DIR** variabless can be set to a local directory. If this project is built for the first time, these directories must be created manually before the build is started. If the variables are not set, the default directories in the build directory are used.

As example:

    export SSTATE_DIR="${HOME}/yocto-cache/riscv64-kirkstone/riscv-sstate-cache"
    export DL_DIR="${HOME}/yocto-cache/riscv64-kirkstone/yocto-downloads"

### KAS

The recommended build flow is to use kas, which is a Python based tool that provides an easy mechanism to setup a bitbake project. The configuration file [build.yml](build.yml) provides all required settings. See [kas documentation](https://kas.readthedocs.io/en/latest/command-line.html) for more details.

#### Installation

    pip install kas

#### Usage \#1

Use following command to build the target specified in the build.yml file (default = refdes-me-mp1-250-si-d3en-pe1).

    kas build build.yml

#### Usage \#2

Use following command to specify the bitbake command to be executed. **MACHINE** variable can be overridden according to section [Supported Machine Targets](#supported-machine-targets).

    kas shell build.yml -c 'MACHINE=refdes-me-mp1-250-si-d3en-pe1 bitbake image-minimal-hwtest'

Note that the image [image-minimal-hwtest](meta-enclustra-refdes/recipes-core/images/image-minimal-hwtest.bb) can be replaced by any available image recipe. Following are a few examples provided by openembedded-core layer:
- core-image-base
- core-image-minimal
- core-image-minimal-dev
- core-image-x11

#### Usage \#3

The tool kas can be used to checkout the repositories and setup the build directory. The build process can be started independently with bitbake as shown in following example.

    kas checkout build.yml
    source openembedded-core/oe-init-build-env
    MACHINE=refdes-me-mp1-250-si-d3en-pe1 bitbake image-minimal-hwtest

## Deployment

The OpenEmbedded Image Creator (wic) creates a partitioned image file for SD card/eMMC. The partitions are configured in the OpenEmbedded kickstart file ([enclustra-mercury-mp1.wks](meta-enclustra-refdes/wic/enclustra-mercury-mp1.wks)). The image file to be deployed on SD card/eMMC can be found in **build/tmp-glibc/deploy/images/\<MACHINE\>** directory, e.g. **image-minimal-hwtest-refdes-me-mp1-250-si-d3en-pe1.wic**.

To be able to boot Linux, the SoC must be programmed with the [bitstream](#fpga-reference-designs-for-microchip-libero) and [HSS](#hart-software-services).

### Creating a Bootable SD Card

Copy the image file to an SD card e.g.

    dd if=image-minimal-hwtest-refdes-me-mp1-250-si-d3en-pe1.wic of=<device> && sync

Note that the device of the SD card (\<device\>) needs to be replaced with the SD card device on your host (e.g. /dev/sdd).

### eMMC Memory

Connect the USB device port of the base board to a host PC and configure the DIP switches of the base board for USB device operation.
When the boot process is stopped in the HSS (by pressing any key), an USB service can be started by typing **usbdmsc**.
This service attaches the eMMC memory as a pen drive to the host PC and the wic image can be copied to the eMMC as described in section [Creating a Bootable SD Card](#Creating-a-Bootable-SD-Card).
No SD card must be inserted in the SD card slot of the base board. If an SD card is inserted, the pen drive shows the SD card instead of the eMMC memory.

:warning: Make sure to disconnect the USB cable of the base board before booting Linux. Linux is configured to use USB in host mode by default.

## Login on Target

Login with **root** as user name, no password is set.

## Devicetree

Linux and U-Boot share most of the devicetree source files to avoid duplicated code.
This is achieved by linking the kernel devicetree sources to U-Boot in the meta-enclustra-mpfs layers.

Following list show all devicetree include files added by meta-enclustra-module layer:

| File name                                                                                                                                        | Description |
|--------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [enclustra_mercury_mp1.dts](meta-enclustra-module/recipes-bsp/device-tree/files/enclustra_mercury_mp1.dts)                                       | Top level devicetree placeholder. File is replaced by meta-enclustra-refdes |
| [enclustra_mercury_mp1.dtsi](meta-enclustra-module/recipes-bsp/device-tree/files/me-mp1-250-si-d3en/enclustra_mercury_mp1.dtsi)                  | Contains nodes and properties that are specific to the me-mp1-250-si-d3en product model as DDR4 memory size |
| [enclustra_mercury_mp1.dtsi](meta-enclustra-module/recipes-bsp/device-tree/files/me-mp1-250-si-d3en-e1/enclustra_mercury_mp1.dtsi)               | Contains nodes and properties that are specific to the me-mp1-250-si-d3en-e1 product model as DDR4 memory size |
| [enclustra_mercury_mp1_common.dtsi](meta-enclustra-module/recipes-bsp/device-tree/files/enclustra_mercury_mp1_common.dtsi)                       | Common definitions that are valid for all Mercury+ MP1 product models |
| [enclustra_mercury_mp1_common_fabric.dtsi](meta-enclustra-module/recipes-bsp/device-tree/files/enclustra_mercury_mp1_common_fabric.dtsi)         | Common definitions for FPGA fabric nodes that are valid for all Mercury+ MP1 product models |
| [enclustra_mercury_mp1-u-boot.dtsi](meta-enclustra-module/recipes-bsp/u-boot/devicetree/me-mp1-250-si-d3en/enclustra_mercury_mp1-u-boot.dtsi)    | U-Boot include file for me-mp1-250-si-d3en |
| [enclustra_mercury_mp1-u-boot.dtsi](meta-enclustra-module/recipes-bsp/u-boot/devicetree/me-mp1-250-si-d3en-e1/enclustra_mercury_mp1-u-boot.dtsi) | U-Boot include file for me-mp1-250-si-d3en-e1 |

Following list show all devicetree include files added by meta-enclustra-refdes layer:

| File name                                                                                                                                        | Description |
|--------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [enclustra_mercury_mp1.dts](meta-enclustra-refdes/recipes-bsp/device-tree/files/enclustra_mercury_mp1.dts)                                       | Top level devicetree file for Linux |
| [enclustra_mercury_mp1.dts](meta-enclustra-refdes/recipes-bsp/u-boot/devicetree/enclustra_mercury_mp1.dts)                                       | Top level devicetree file for U-Boot |
| [enclustra_mercury_mp1_fabric.dtsi](meta-enclustra-refdes/recipes-bsp/device-tree/files/me-pe1-generic/enclustra_mercury_mp1_fabric.dtsi)        | Devicetree nodes in FPGA fabric for PE1 reference designs |
| [enclustra_mercury_mp1_fabric.dtsi](meta-enclustra-refdes/recipes-bsp/device-tree/files/me-pe3-generic/enclustra_mercury_mp1_fabric.dtsi)        | Devicetree nodes in FPGA fabric for PE3 reference designs |
| [enclustra_mercury_mp1_fabric.dtsi](meta-enclustra-refdes/recipes-bsp/device-tree/files/me-st1-generic/enclustra_mercury_mp1_fabric.dtsi)        | Devicetree nodes in FPGA fabric for ST1 reference designs |
| [enclustra_mercury_baseboard.dtsi](meta-enclustra-refdes/recipes-bsp/device-tree/files/me-pe1-generic/enclustra_mercury_baseboard.dtsi)          | Mercury+ PE1 base board specific devicetree properties |
| [enclustra_mercury_baseboard.dtsi](meta-enclustra-refdes/recipes-bsp/device-tree/files/me-pe3-generic/enclustra_mercury_baseboard.dtsi)          | Mercury+ PE3 base board specific devicetree properties |
| [enclustra_mercury_baseboard.dtsi](meta-enclustra-refdes/recipes-bsp/device-tree/files/me-st1-generic/enclustra_mercury_baseboard.dtsi)          | Mercury+ ST1 base board specific devicetree properties |

The devicetree uses following file structure:

    enclustra_mercury_mp1.dts
    ├── enclustra_mercury_mp1.dtsi                           -> Depending on product model: me-mp1-250-si-d3en or me-mp1-250-si-d3en-e1
    │    └── enclustra_mercury_mp1_common.dtsi
    │        └── mpfs.dtsi                                   -> Provided by kernel sources
    ├─────── enclustra_mercury_baseboard.dtsi                -> Depending on reference design: PE1, ST1 or PE3
    └─────── enclustra_mercury_mp1_fabric.dtsi               -> Depending on reference design: PE1, ST1 or PE3
             └── enclustra_mercury_mp1_common_fabric.dtsi

### Modification for eMMC boot

On the Mercury+ MP1 product series, the MSS MMC controller is connected through a multiplexer to an eMMC memory located on the module and to an SD card slot located on the base board. During the boot process, the HSS selects one of the two devices depending on if an SD card is inserted in the SD card slot. If an SD card is inserted, the system boots from SD card, otherwise it boots from eMMC.

The default devicetree works for both SD card and eMMC memory, but the eMMC performance is limited. The devicetree needs to be modified for full eMMC support (use of 8 data lanes instead of only 4) with the disadvantage that SD card is not supported anymore.

In file [enclustra_mercury_mp1_common.dtsi](meta-enclustra-module/recipes-bsp/device-tree/files/enclustra_mercury_mp1_common.dtsi) in 'mmc' node, following settings needs to be removed or commented out:

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

## Patches

### U-Boot

Following U-Boot patches are added.

| Patch Name                                                                                                                                                                          | Description |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [0001-Enclustra-MAC-address-readout-from-EEPROM.patch](meta-enclustra-module/recipes-bsp/u-boot/patches/0001-Enclustra-MAC-address-readout-from-EEPROM.patch)                       | Add a feature to read and configure the MAC address from atsha204a EEPROM |
| [0002-Board-files-for-Mercury-MP1-added.patch](meta-enclustra-module/recipes-bsp/u-boot/patches/0002-Board-files-for-Mercury-MP1-added.patch)                                       | Add support for Mercury+ MP1 product series |
| [0003-Devicetree-for-Mercury-MP1-added.patch](meta-enclustra-module/recipes-bsp/u-boot/patches/0003-Devicetree-for-Mercury-MP1-added.patch)                                         | Add MP1 devicetree to Makefile |
| [0004-PolarFire-SoC-I2C-driver-modification-for-zero-sized.patch](meta-enclustra-module/recipes-bsp/u-boot/patches/0004-PolarFire-SoC-I2C-driver-modification-for-zero-sized.patch) | Remove check in Microchip I2C driver to allow wakeup of atsha204a by transmitting only 1 byte |
| [0005-Bugfix-for-atsha204a-driver.patch](meta-enclustra-module/recipes-bsp/u-boot/patches/0005-Bugfix-for-atsha204a-driver.patch)                                                   | Fix wakeup sequence in atsha204a driver |
| [0006-Rename-mpfs-devicetree.patch](meta-enclustra-module/recipes-bsp/u-boot/patches/0006-Rename-mpfs-devicetree.patch)                                                             | Rename microchip-mpfs.dtsi to mpfs.dtsi to be able to reuse the devicetree from Linux kernel |
| [0007-SI5338-configuration.patch](meta-enclustra-refdes/recipes-bsp/u-boot/patches/0007-SI5338-configuration.patch)                                                                 | Add configuration of SI5338 clock generator in U-Boot |

### Linux Kernel

Following Linux kernel patches are added.

| Patch Name                                                                                                                                                                            | Description |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [0001-Add-atsha204a-driver-with-support-to-read-OTP-region.patch](meta-enclustra-module/recipes-kernel/linux/patches/0001-Add-atsha204a-driver-with-support-to-read-OTP-region.patch) | Add driver to read serial number from EEPROM |
| [0002-spi-microchip-core-prevent-RX-overflows-when-transmi.patch](meta-enclustra-module/recipes-kernel/linux/patches/0002-spi-microchip-core-prevent-RX-overflows-when-transmi.patch) | Bugfix for SPI driver |

## Additional Information

### Memory Layout

The 2 Gbyte available memory of the me-mp1-250-si-d3en and me-mp1-250-si-d3en-e1 modules is accessible at following physical addresses.

| Address        | Size      | DDR Memory Address Offset | Comment |
|----------------|-----------|---------------------------|---------------------|
| 0xc000'0000    | 64 Mbyte  | 0x0                       | Reserved for DMA |
| 0x8400'0000    | 960 Mbyte | 0x400'0000                | |
| 0x10'0000'0000 | 1 Gbyte   | 0x4000'0000               | |

### Ethernet MAC address configuration

Each Enclustra module is delivered with two unique MAC addresses stored in the EEPROM. During the boot process, these MAC addresses are automatically read by U-Boot and configured to be used by U-Boot and Linux.

### Reading Serial Number of Module

The serial number of the module can be read by following command:

    cat /sys/bus/i2c/devices/1-0064/serial

The serial number is reported as follows:

    248173

### Read OTP Region of EEPROM

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

The size of the rootfs partition is set to 128 Mbyte by default. To change the partition size, the OpenEmbedded kickstart file [enclustra-mercury-mp1.wks](meta-enclustra-refdes/wic/enclustra-mercury-mp1.wks) needs to be modified. The partition size is defined by **--fixed-size** parameter as shown below.

```
part / --source rootfs --ondisk mmcblk0 --fstype=ext4 --label root --align 4096 --fixed-size 128M
```

### Configure SI5338 Clock Generator on Mercury+ PE1 and Mercury+ ST1 Base Board

The U-Boot patch [0007-SI5338-configuration.patch](meta-enclustra-refdes/recipes-bsp/u-boot/patches/0007-SI5338-configuration.patch) adds support to configure the clock generator device. To enable the configuration, follow the steps below:

1. Create a configuration with Skyworks [ClockBuilder Pro software](https://www.skyworksinc.com/Application-Pages/Clockbuilder-Pro-Software) and export the C code header file.
2. Copy the exported header file to **meta-enclustra-refdes/recipes-bsp/u-boot/files/** directory and overwrite the example file [Si5338-RevB-Registers.h](meta-enclustra-refdes/recipes-bsp/u-boot/files/Si5338-RevB-Registers.h)
3. Make following changes to file [clockgen.cfg](meta-enclustra-refdes/recipes-bsp/u-boot/files/clockgen.cfg):

       CONFIG_SI5338_CONFIGURATION=y

### SPI Flash Access

If the BOOT_MODE0 pin on Mercury+ MP1 modules is driven to logic '1' or left unconnected, the FPGA SPI flash is connected to the SoC device. It can be accessed in Linux via its MTD partition. As shown below, mtd0 is the QSPI flash connected to the MSS pins and mtd1 is the SPI flash connected via FPGA system controller.

```
# mtdinfo -a
Count of MTD devices:           2
Present MTD devices:            mtd0, mtd1
Sysfs interface supported:      yes

mtd0
Name:                           mss-flash
Type:                           nor
Eraseblock size:                262144 bytes, 256.0 KiB
Amount of eraseblocks:          256 (67108864 bytes, 64.0 MiB)
Minimum input/output unit size: 1 byte
Sub-page size:                  1 byte
Character device major/minor:   90:0
Bad blocks are allowed:         false
Device is writable:             true

mtd1
Name:                           spi2.0
Type:                           nor
Eraseblock size:                262144 bytes, 256.0 KiB
Amount of eraseblocks:          256 (67108864 bytes, 64.0 MiB)
Minimum input/output unit size: 1 byte
Sub-page size:                  1 byte
Character device major/minor:   90:2
Bad blocks are allowed:         false
Device is writable:             true
```

### I2C

Multiple I2C buses are available in U-Boot and Linux. The table below shows all relevant information. The default speed it set to 100kHz.

| Bus | Pins                       | Master          | Comment |
|-----|----------------------------|-----------------|---------|
| 0   | GPIO bank 1, pin E7/F7     | MSS I2C_0       | |
| 1   | MSS bank 2, pin MSSIO26/27 | MSS I2C_1       | |
| 2   | GPIO bank 7, pin L10/K10   | CoreI2C in FPGA | Only available on Mercury+ PE3 and Mercury+ ST1 base board / not available in U-Boot |

## Known Issues:

#### Minimal I2C Frequency

The clock frequency of the I2C bus is derived from the MSS AHB/APB bus clock. This clock is set to 150MHz by default. Because the biggest possible divider value is 960, the slowest possible I2C frequency is 150MHz/960=156.25kHz. With this
156.25kHz I2C clock frequency, the wake-up pulse duration of the Atmel ATSHA204a device is violated (52us instead of 60us). Measurements has shown that the device wakes up reliable when the wake-up pulse is bigger than 30us.
