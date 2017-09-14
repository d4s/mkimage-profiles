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
	@$(call add,SERVICES_DISABLE,mysqld mongod)

distro/.live-evm: distro/.live-base \
		  use/bootloader/grub \
		  use/relname \
		  use/isohybrid use/syslinux/timeout/30 \
		  use/init/systemd \
		  distro/.evm_services

distro/live-evm-cluster: distro/.live-evm \
			 use/evm/cluster \
			 use/evm/virt \
			 use/evm/devel
	@$(call set,RELNAME,EVM-Cluster)
	@$(call set,META_VOL_ID,BSUIR EVM $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,BSUIR EVM)
	@$(call try,HOMEPAGE,http://bsuir.by)
	@$(call try,HOMENAME,BSUIR)
	@$(call add,LIVE_LISTS,domain-client)

distro/live-evm-virt: distro/.live-evm \
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

distro/live-evm-desktop: distro/regular-xfce distro/.live-desktop-ru  \
			 distro/.live-evm \
			 use/evm/virt \
			 use/evm/devel \
			 use/evm/cluster \
			 use/evm/desktop \
			 use/live/autologin use/branding \
			 use/x11/3d
#			 use/x11/kde4/nm +nm
	@$(call add,SERVICES_DISABLE,pbs_mom distccd)
	@$(call set,BRANDING,simply-linux)
	@$(call set,KFLAVOURS,std-def)
#	@$(call set,KFLAVOURS,un-def)
	@$(call set,RELNAME,EVM-Desktop)
	@$(call add,LIVE_LISTS,evm/devel-java)
	@$(call add,THE_BRANDING,menu xfce-settings)
	@$(call add,THE_BRANDING,bootloader bootsplash graphics)
	@$(call add,STAGE2_BOOTARGS,nouveau.modeset=0)


endif
