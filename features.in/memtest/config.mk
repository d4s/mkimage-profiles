use/memtest: use/syslinux
	@$(call add,FEATURES,memtest)
	@$(call add,COMMON_PACKAGES,memtest86+)
	@$(call add,SYSLINUX_CFG,memtest)
