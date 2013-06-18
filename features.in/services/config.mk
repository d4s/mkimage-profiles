use/services: sub/rootfs
	@$(call add_feature)
	@$(call xport,DEFAULT_SERVICES_ENABLE)
	@$(call xport,DEFAULT_SERVICES_DISABLE)
	@$(call xport,SERVICES_ENABLE)
	@$(call xport,SERVICES_DISABLE)

# some presets

use/services/network: use/services
	@$(call add,DEFAULT_SERVICES_ENABLE,network)

use/services/ssh: use/services use/services/network
	@$(call add,DEFAULT_SERVICES_ENABLE,sshd)
