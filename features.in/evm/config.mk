use/evm/cluster: use/live/hooks 
	@$(call add,LIVE_PACKAGES,livecd-save-nfs)
	@$(call add,LIVE_LISTS,evm-cluster)
	@$(call add,LIVE_KMODULES,kvm)
	@$(call add,CLEANUP_PACKAGES,'kernel-modules-drm-nouveau*')

use/evm/desktop: use/evm/cluster use/live/desktop
	@$(call add,LIVE_LISTS, $(call tags,(base || extra) && (archive || rescue || network)))
	@$(call add,LIVE_LISTS,evm)
	@$(call add,LIVE_LISTS,gns3)
	@$(call add,LIVE_KMODULES,kvm virtualbox)
	@$(call set,META_SYSTEM_ID,LINUX)
	@$(call set,META_VOL_ID,BSUIR EVM $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,BSUIR EVM)

