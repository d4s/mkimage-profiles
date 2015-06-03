use/evm: use/live/hooks use/live/rw +efi \
	 use/evm/services use/evm/control use/evm/deflogin
	@$(call add_feature)
	@$(call add,LIVE_PACKAGES,livecd-save-nfs)
	@$(call add,THE_KMODULES,nvidia kvm)
	@$(call set,META_VOL_ID,BSUIR EVM $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,BSUIR EVM)

use/evm/services: use/services
	@$(call add,DEFAULT_SERVICES_ENABLE, rpcbind sshd kheaders)
	@$(call add,DEFAULT_SERVICES_ENABLE, xinetd smartd bluetoothd)
	@$(call add,DEFAULT_SERVICES_ENABLE, x11presetdrv NetworkManager)
	@$(call add,DEFAULT_SERVICES_ENABLE, livecd-save-nfs alteratord)
	@$(call add,DEFAULT_SERVICES_ENABLE, virtualbox libvirtd)

	@$(call add,DEFAULT_SERVICES_DISABLE, bind cups livecd-online-repo)

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

use/evm/desktop: use/evm +robotics use/live/ru use/live/install
#use/evm/desktop: use/evm/cluster use/evm/devel distro/regular-kde4 +robotics use/live/ru
	@$(call add,LIVE_LISTS, $(call tags,(base || extra) && (archive || network)))
	@$(call add,LIVE_LISTS,evm/desktop)
#	@$(call add,LIVE_LISTS,gns3)
	@$(call add,the_KMODULES,virtualbox)

