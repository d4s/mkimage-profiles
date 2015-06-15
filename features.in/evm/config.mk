use/evm: use/live/hooks use/live/rw +efi \
	 use/evm/control use/evm/deflogin
	@$(call add_feature)
	@$(call add,LIVE_PACKAGES,livecd-save-nfs)
	@$(call add,CLEANUP_PACKAGES,'kernel-modules-drm-nouveau*')
	@$(call add,THE_KMODULES,nvidia kvm kvm-amd kvm-intel)
	@$(call set,META_VOL_ID,BSUIR EVM $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,BSUIR EVM)

use/evm/control: use/control
	@$(call add,CONTROL,wireshark-capture:public)
	@$(call add,CONTROL,fusermount:public)
	@$(call add,CONTROL,nfsmount:public)
	@$(call add,CONTROL,ppp:public)

use/evm/deflogin: use/deflogin
	@$(call add,GROUPS,vboxusers vmusers netadmin _alteratord)

use/evm/cluster: use/evm
	@$(call add,LIVE_LISTS,evm/cluster)
#	@$(call add,LIVE_LISTS,evm/cuda)


use/evm/devel: use/evm use/dev/builder/full
	@$(call add,LIVE_LISTS,evm/devel)

use/evm/desktop: use/evm +robotics use/live/ru use/live/install use/live/desktop
#use/evm/desktop: use/evm/cluster use/evm/devel distro/regular-kde4 +robotics use/live/ru
	@$(call add,LIVE_LISTS, $(call tags,(base || extra) && (archive || network)))
	@$(call add,LIVE_LISTS,evm/desktop)
	@$(call add,LIVE_LISTS,evm/games)
#	@$(call add,LIVE_LISTS,gns3)
	@$(call add,the_KMODULES,virtualbox)

