# evm images
ifeq (distro,$(IMAGE_CLASS))
distro/live-evm-desktop: distro/.live-desktop-ru use/live/autologin use/x11/3d-proprietary use/evm/desktop
	@$(call try,HOMEPAGE,http://bsuir.by)
	@$(call try,HOMENAME,BSUIR)

distro/live-evm-cluster: distro/.live-base use/evm/cluster use/relname
	@$(call set,KFLAVOURS,led-ws)
	@$(call try,HOMEPAGE,http://bsuir.by)
	@$(call try,HOMENAME,BSUIR)
	@$(call set,RELNAME,EVM-Cluster)
	@$(call set,META_SYSTEM_ID,LINUX)
	@$(call set,META_VOL_ID,BSUIR EVM $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,BSUIR EVM)
endif
