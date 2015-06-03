# evm images
ifeq (distro,$(IMAGE_CLASS))
distro/live-evm-cluster: distro/.live-base use/evm/cluster use/evm/devel use/relname
	@$(call set,RELNAME,EVM-Cluster)
	@$(call set,META_VOL_ID,BSUIR EVM $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,BSUIR EVM)
	@$(call try,HOMEPAGE,http://bsuir.by)
	@$(call try,HOMENAME,BSUIR)
	@$(call add,LIVE_LISTS,domain-client)

distro/live-evm-devel: distro/live-evm-cluster  use/evm/cluster use/evm/devel  use/relname use/init/systemd
	@$(call set,KFLAVOURS,un-def)
	@$(call set,RELNAME,EVM-Devel)

distro/live-evm-desktop: distro/regular-kde4 distro/live-evm-devel distro/.live-desktop-ru use/x11-autologin use/x11/3d use/evm/desktop use/branding
#	@$(call set,BRANDING,altlinux-p7)
	@$(call set,RELNAME,EVM-Desktop)
endif
