use/domain-client: use/net/dhcp
	@$(call add_feature)
	@$(call add,THE_LISTS,domain-client)
	@$(call add,DEFAULT_SERVICES_ENABLE,avahi-daemon)
