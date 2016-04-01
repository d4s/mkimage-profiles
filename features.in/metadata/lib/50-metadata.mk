# step 4: build the distribution image

# package lists are needed for installer and live-install images
METADIR := files/Metadata

# preparation targets of features.in/build-distro/lib/build-distro.mk
WHATEVER += metadata

# handle these too
DOT_BASE += $(BASE_PACKAGES_REGEXP)

# args: type, name
define dump
if [ -n "$($(2)_$(1))" ]; then \
	echo -e "\n## $(2)_$(1)"; \
	case "$(1)" in \
	PACKAGES) echo "$($(2)_$(1))";; \
	LISTS) echo -e "\n# $($(2)_$(1))"; cat $($(2)_$(1));; \
	esac; \
fi;
endef

# BASE_PACKAGES, BASE_LISTS and whatever else goes into base install;
# thus construct requisite .base packagelist for alterator-pkg
metadata-.base:
	@cd $(call list,/); \
	{ \
		echo "## generated by features.in/metadata/lib/50-metadata.mk";\
		$(foreach p,SYSTEM COMMON THE BASE,$(call dump,PACKAGES,$(p))) \
		$(foreach l,THE BASE,$(call dump,LISTS,$(l))) \
		if [ -n "$(DOT_BASE)" ]; then \
			echo -e "\n## DOT_BASE\n$(DOT_BASE)"; \
		fi; \
	} | sed -re '/^[^[:space:]#]/ s/[[:space:]]+/\n/g' > .base

# see also alterator-pkg (backend3/pkg-install);
# we only tar up what's up to it
metadata: metadata-.base
	@mkdir -p $(METADIR); \
	tar -C $(PKGDIR) -cvf - \
		$(call rlist,$(THE_GROUPS) $(MAIN_GROUPS) .base) \
		$(call rgroup,$(THE_GROUPS) $(MAIN_GROUPS)) \
		$(call rprofile,$(PKG_PROFILES)) \
	> $(METADIR)/pkg-groups.tar
