use/evm: use/live/hooks
	@$(call add_feature)
	@$(call add,LIVE_PACKAGES,livecd-save-nfs)
	@$(call add,LIVE_KMODULES,kvm)
	@$(call add,CLEANUP_PACKAGES,'kernel-modules-drm-nouveau*')
	@$(call set,META_SYSTEM_ID,LINUX)
	@$(call set,META_VOL_ID,BSUIR EVM $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,BSUIR EVM)

use/evm/cluster: use/evm
	@$(call add,LIVE_LISTS,evm-cluster)

use/evm/devel: use/evm
	@$(call add,LIVE_LISTS,evm-devel)

use/evm/desktop: use/evm use/live/desktop
	@$(call add,LIVE_LISTS, $(call tags,(base || extra) && (archive || rescue || network)))
	@$(call add,LIVE_LISTS,evm)
	@$(call add,LIVE_LISTS,gns3)
	@$(call add,LIVE_KMODULES,virtualbox)

