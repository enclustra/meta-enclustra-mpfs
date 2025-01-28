# Yocto BSP Layer for Enclustra Modules equipped with Microchip SoCs

This layer provides support for Enclustra System-on-Chip modules equipped with Microchip Polarfire SoCs.

For more information on available Enclustra Modules, please visit:

https://www.enclustra.com/en/products/system-on-chip-modules/

# Dependencies

This Yocto layer depends on:

URI: https://git.openembedded.org/openembedded-core<br>
layers: meta<br>
revision: 077aab43f2c928eb8da71934405c62327010f552

URI: https://github.com/polarfire-soc/meta-polarfire-soc-yocto-bsp<br>
layers: meta-polarfire-soc-bsp<br>
branch: v2024.09<br>
revision: 4bb061e61cc9e9d3889221a0cb4a42d99033ee6d

URI https://git.yoctoproject.org/meta-security<br>
layers: meta-tpm<br>
revision: b9cf9cd639bc8d1b4828eb0bd012b71486d35176

URI https://git.openembedded.org/meta-openembedded<br>
layers: meta-oe, meta-python, meta-networking<br>
revision: de8681b4a2a101b99dd2c48d89a7de2ccd9a961f

# Submit Patches / Reporting Bugs

Please report bugs or submit patches against the meta-enclustra-mpfs layer to following address:

support@enclustra.com

# Building Instructions

See [README](../README.md)

# License

All metadata is MIT licensed unless otherwise stated. Source code included in tree for individual recipes are under the LICENSE stated in the associated recipe (.bb file) unless otherwise stated.
