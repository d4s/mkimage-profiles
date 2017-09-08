ifeq (ve,$(IMAGE_CLASS))

# no "vzctl enter"
ve/bare: ve/.base +sysvinit; @:

# /dev/pty and friends start here
ve/base: ve/bare use/net-dns/level3
	@$(call add,BASE_PACKAGES,interactivesystem)

# a particular package list
ve/ldv: ve/bare use/control/server/ldv
	@$(call add,BASE_PACKAGES,xz bzip2 glibc hostinfo less)
	@$(call add,BASE_PACKAGES,vim-console netlist rsync time)
	@$(call add,BASE_PACKAGES,openssh-blacklist openssh-server)
	@$(call add,BASE_PACKAGES,shadow-edit shadow-groups)

ve/docker: ve/.base use/repo; @:

# build environment
ve/builder: ve/base use/dev/builder/base use/repo
	@$(call add,BASE_LISTS,openssh)

# this should be more or less convenient
ve/generic: ve/base use/repo
	@$(call add,BASE_PACKAGES,vim-console etckeeper)
	@$(call add,BASE_LISTS,openssh \
		$(call tags,base && (server || network || security || pkg)))

# example of service-specific template
ve/openvpn: ve/bare
	@$(call add,BASE_LISTS,$(call tags,server openvpn))

ve/pgsql94: ve/generic
	@$(call add,BASE_PACKAGES,postgresql9.4-server)

ve/samba-DC: ve/generic
	@$(call add,BASE_PACKAGES,task-samba-dc glibc-locales net-tools)

ve/systemd-bare: ve/.base use/net/networkd +systemd \
	use/control/sudo-su use/repo use/net-ssh
	@$(call add,BASE_PACKAGES,interactivesystem su)

ve/evm-devel: ve/systemd-bare \
	      use/evm/devel
	@$(call set,RELNAME,EVM-Devel)

ve/evm-devel: ve/systemd-bare \
	      use/evm/devel
	@$(call set,RELNAME,EVM-Devel)

endif
