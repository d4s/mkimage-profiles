# step 4: build the distribution image

# for complex-specified subprofiles like stage2/live,
# take the latter part
SUBDIRS = $(notdir $(SUBPROFILES))

# proxy over the ISO metadata collected; see also genisoimagerc(5)
BOOT_SYSI := $(META_SYSTEM_ID)
BOOT_PUBL := $(META_PUBLISHER)
BOOT_PREP := $(META_PREPARER)
BOOT_APPI := $(META_APP_ID)
BOOT_VOLI := $(META_VOL_ID)
BOOT_VOLS := $(META_VOL_SET)
BOOT_BIBL := $(META_BIBLIO)
BOOT_ABST := $(META_ABSTRACT)

BOOT_TYPE := isolinux

# see also ../scripts.d/01-isosort; needs mkimage-0.2.2+
MKI_SORTFILE := /tmp/isosort

all: $(GLOBAL_DEBUG) prep copy-subdirs copy-tree run-scripts pack-image \
	postprocess $(GLOBAL_CLEAN_WORKDIR)

prep: $(GLOBAL_DEBUG) dot-disk $(WHATEVER) imagedir
#prep: $(GLOBAL_DEBUG) dot-disk metadata imagedir

dot-disk:
	@mkdir -p files/.disk
	@echo "ALT Linux based" >files/.disk/info
	@echo "$(ARCH)" >files/.disk/arch
	@echo "$(DATE)" >files/.disk/date
	@if type -t git >&/dev/null; then \
		( cd $(TOPDIR) && test -d .git && \
		git show-ref --head -ds -- HEAD ||:) \
		>files/.disk/commit 2>/dev/null; \
	fi