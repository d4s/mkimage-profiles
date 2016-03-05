# evm images
ifeq (distro,$(IMAGE_CLASS))

distro/.evm_services: use/services
	@$(call add,SERVICES_ENABLE,rpcbind sshd kheaders)
	@$(call add,SERVICES_ENABLE,xinetd smartd bluetoothd)
	@$(call add,SERVICES_ENABLE,x11presetdrv NetworkManager)
	@$(call add,SERVICES_ENABLE,livecd-save-nfs alteratord)
	@$(call add,SERVICES_ENABLE,virtualbox libvirtd)
	@$(call add,SERVICES_ENABLE,lxd lxc-net lxcfs cgmanager)
	@$(call add,SERVICES_ENABLE,getty@tty1 getty@ttyS0)
	@$(call add,SERVICES_ENABLE,livecd-net-eth)
	@$(call add,SERVICES_DISABLE,livecd-online-repo livecd-tmpfs)
	@$(call add,SERVICES_DISABLE,bind cups)
	@$(call add,SERVICES_DISABLE,systemd-journald)
	@$(call add,SERVICES_DISABLE,livecd-online-repo livecd-tmpfs)

distro/live-evm-cluster: distro/.live-base distro/.evm_services \
			 use/evm/cluster use/evm/devel use/relname
	@$(call set,RELNAME,EVM-Cluster)
	@$(call set,META_VOL_ID,BSUIR EVM $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,BSUIR EVM)
	@$(call try,HOMEPAGE,http://bsuir.by)
	@$(call try,HOMENAME,BSUIR)
	@$(call add,LIVE_LISTS,domain-client)

distro/live-evm-virt: distro/.base distro/.evm_services \
		       use/power/acpi/button use/relname \
		       use/evm/virt \
		       use/tty/S0 \
		       use/init/systemd/multiuser
	@$(call set,KFLAVOURS,un-def)
	@$(call set,RELNAME,EVM-Virtual)

distro/live-evm-devel: distro/live-evm-virt \
		       use/evm/devel
#	@$(call set,KFLAVOURS,un-def)
	@$(call set,KFLAVOURS,std-def)
	@$(call set,RELNAME,EVM-Devel)

distro/live-evm-desktop: distro/regular-kde4 distro/.live-desktop-ru  \
			 distro/live-evm-cluster \
			 use/evm/devel use/evm/desktop \
			 use/live/autologin use/branding \
			 use/x11/3d use/x11/nvidia/optimus \
			 use/x11/kde4/nm +nm \
			 use/init/systemd \
			 use/isohybrid use/syslinux/timeout/30
#	@$(call set,BRANDING,altlinux-p7)
	@$(call set,KFLAVOURS,std-def)
	@$(call set,RELNAME,EVM-Desktop)

endif
