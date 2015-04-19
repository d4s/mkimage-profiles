# alterator-based installer, second (livecd) stage

+installer: use/install2/full; @:

use/install2: use/stage2 sub/stage2@install2 use/metadata \
	use/cleanup/installer
	@$(call add_feature)
	@$(call try,INSTALLER,altlinux-generic)	# might be replaced later
	@$(call add,INSTALL2_PACKAGES,installer-distro-$$(INSTALLER)-stage2)
	@$(call add,INSTALL2_PACKAGES,branding-$$(BRANDING)-alterator)
	@$(call add,BASE_PACKAGES,branding-$$(BRANDING)-release)
	@$(call add,BASE_PACKAGES,installer-common-stage3)
	@$(call add,BASE_LISTS,$(call tags,basesystem))
	@$(call xport,BASE_BOOTLOADER)
	@$(call xport,INSTALL2_CLEANUP_PACKAGES)
	@$(call xport,INSTALL2_CLEANUP_KDRIVERS)

# doesn't use/install2/fs on purpose (at least so far)
use/install2/full: use/install2/packages use/install2/vmguest \
	use/syslinux/localboot.cfg use/syslinux/ui/menu use/bootloader; @:

# see also use/vmguest
use/install2/vmguest: use/install2/kvm use/install2/vbox use/install2/vmware; @:

# stash local packages within installation media
use/install2/packages: use/install2 use/repo/main; @:

# set up remote repositories within installed system out-of-box
use/install2/repo: use/install2
	@$(call add,INSTALL2_PACKAGES,installer-feature-online-repo)

# for alterator-pkg to use
use/install2/net: use/install2
	@$(call add,INSTALL2_PACKAGES,curl)

# see also use/vmguest/kvm; qxl included in xorg pkglist
use/install2/kvm:
	@$(call add,INSTALL2_PACKAGES,spice-vdagent xorg-drv-qxl)

# virtualbox guest support for installer
use/install2/vbox:
	@$(call add,STAGE1_KMODULES,virtualbox-addition vboxguest)

# see also use/vmguest/vmware
use/install2/vmware:
	@$(call add,STAGE1_KMODULES,vmware)
	@$(call add,STAGE1_KMODULES,scsi)	# mptspi in led-ws
	@$(call add,INSTALL2_PACKAGES,xorg-drv-vmware)

# NB: sort of conflicts with use/install2/cleanup/vnc
use/install2/vnc:
	@$(call add,INSTALL2_PACKAGES,x11vnc)

# filesystems handling
use/install2/fs: use/install2/xfs use/install2/jfs use/install2/reiserfs; @:

use/install2/xfs:
	@$(call add,SYSTEM_PACKAGES,xfsprogs)

use/install2/jfs:
	@$(call add,SYSTEM_PACKAGES,jfsutils)

use/install2/reiserfs:
	@$(call add,SYSTEM_PACKAGES,reiserfsprogs)

# prepare bootloader for software suspend (see also live)
use/install2/suspend:
	@$(call add,INSTALL2_PACKAGES,installer-feature-desktop-suspend-stage2)

# when VNC installation is less welcome than a few extra megs
use/install2/cleanup/vnc:
	@$(call add,INSTALL2_CLEANUP_PACKAGES,x11vnc xorg-xvfb)

# conflicts with luks feature
use/install2/cleanup/crypto:
	@$(call add,INSTALL2_CLEANUP_PACKAGES,gnupg libgpg-error)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,libgcrypt* libgnutls*)

# leave only cirrus, fbdev, qxl, vesa in vm-targeted images
use/install2/cleanup/x11-hwdrivers:
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-ati xorg-drv-intel)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-glamor)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-mach64 xorg-drv-mga)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-nouveau xorg-drv-nv)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-openchrome)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-r128 xorg-drv-radeon)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-s3virge xorg-drv-savage)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-sis)

# massive purge of anything not critical to installer boot (l10n included!)
use/install2/cleanup/everything: use/install2/cleanup/x11-hwdrivers \
	use/install2/cleanup/vnc use/install2/cleanup/crypto
	@$(call add,INSTALL2_CLEANUP_PACKAGES,glibc-gconv-modules glibc-locales)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,libX11-locales alterator-l10n)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,kbd-data kbd console-scripts)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,shadow-convert)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,libXaw xmessage xconsole)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,libncurses libncursesw) # top
	@$(call add,INSTALL2_CLEANUP_PACKAGES,openssl) # net-functions
	@$(call add,INSTALL2_CLEANUP_PACKAGES,vitmp vim-minimal)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,udev-hwdb pciids)

# this conflicts with efi (which needs efivars.ko)
use/install2/cleanup/kernel/firmware:
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/firmware/)

# drop drivers expected to be useless in virtual environment
use/install2/cleanup/kernel/non-vm:
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/firewire/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/bonding/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/ppp/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/slip/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/team/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/usb/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/platform/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/tty/serial/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/net/bridge/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/net/openvswitch/)

# this would need extra handling anyways
use/install2/cleanup/kernel/storage:
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/block/aoe/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/block/drbd/)

# burn it down
use/install2/cleanup/kernel/everything: \
	use/install2/cleanup/kernel/storage \
	use/install2/cleanup/kernel/non-vm \
	use/install2/cleanup/kernel/firmware
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/ata/pata_*)
