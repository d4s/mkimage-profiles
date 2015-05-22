use/evm: use/live/hooks use/live/rw +efi
	@$(call add_feature)
	@$(call add,LIVE_PACKAGES,livecd-save-nfs)
	@$(call add,LIVE_KMODULES,kvm)
	@$(call add,CLEANUP_PACKAGES,'kernel-modules-drm-nouveau*')
	@$(call set,META_SYSTEM_ID,LINUX)
	@$(call set,META_VOL_ID,BSUIR EVM $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,BSUIR EVM)

use/evm/cluster: use/evm
	@$(call add,LIVE_LISTS,evm-cluster)
#	@$(call add,LIVE_LISTS,evm-cuda)
#	@$(call add,LIVE_LISTS,evm-calibre)

use/evm/devel: use/evm use/dev/builder/full
	@$(call add,LIVE_LISTS,evm-devel)

use/evm/desktop: distro/regular-kde4 +robotics use/live/ru use/live/install
#use/evm/desktop: use/evm/cluster use/evm/devel distro/regular-kde4 +robotics use/live/ru
	@$(call add,LIVE_LISTS, $(call tags,(base || extra) && (archive || network)))
	@$(call add,LIVE_LISTS,evm)
	@$(call add,LIVE_LISTS,gns3)
	@$(call add,LIVE_KMODULES,virtualbox)

