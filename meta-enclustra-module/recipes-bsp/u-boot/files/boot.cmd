# Try to boot a fitImage from the MMC
if load ${devtype} ${devnum}:${distro_bootpart} ${fitimage_addr_r} fitImage; then
    bootm ${fitimage_addr_r}
fi;
