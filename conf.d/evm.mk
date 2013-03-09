# evm images
ifeq (distro,$(IMAGE_CLASS))
distro/evm-desktop: distro/.live-desktop-ru use/live/autologin use/x11/3d-proprietary use/evm/desktop
	@$(call try,HOMEPAGE,http://bsuir.by)
	@$(call try,HOMENAME,BSUIR)

distro/evm-cluster: distro/.live-desktop-ru use/x11/3d-proprietary use/evm/cluster
	@$(call try,HOMEPAGE,http://bsuir.by)
	@$(call try,HOMENAME,BSUIR)
	@$(call set,KFLAVOURS,led-ws)
	@$(call set,RELNAME,EVM-Cluster)
endif
