# Build libressl locally {{{1
#
# See also:
# https://www.libressl.org/

include config.mak # {{{1

SOURCES := sources

PACKAGES := $(basename $(basename $(basename \
	$(shell cd hashes; for h in *; do echo $$h; done))))

DL_CMD := curl -C - -L -o
SHASUM := sha1sum
SPACE := $(subst ,, )
URL := https://ftp.openbsd.org/pub/OpenBSD/LibreSSL

it: # the default goal {{{1

clean:
	rm -rf $(PACKAGES) *.build $(SOURCES)

$(SOURCES):
	mkdir -p $@

$(SOURCES)/%: hashes/%.sha1 | $(SOURCES)
	rm -rf $@.tmp; mkdir -p $@.tmp
	cd $@.tmp && $(DL_CMD) $(notdir $@) $(URL)/$(notdir $@) && touch $(notdir $@)
	cd $@.tmp && $(SHASUM) -c ${CURDIR}/hashes/$(notdir $@).sha1
	mv $@.tmp/$(notdir $@) $@ && rm -rf $@.tmp

%.build: $(SOURCES)/%.tar.gz
	rm -rf $@.tmp; mkdir -p $@.tmp
	( cd $@.tmp && tar zxvf - ) < $<
	rm -rf $@
	touch $@.tmp/$(patsubst %.build,%,$@)
	mv $@.tmp/$(patsubst %.build,%,$@) $@
	rm -rf $@.tmp

%: PKG=$(subst $(SPACE),-,$(strip \
  $(filter-out %.4 %.5,$(subst -, ,$@))))

%: %.build
	$(MAKE) -f $(PKG).mak BUILD_DIR=$<
	touch $@

it: | $(PACKAGES)
	@echo '- $@ built order-only prerequisites: $|'

# Note: .SECONDARY with no prerequisites causes all targets to be treated {{{1
# as secondary. No target is removed because it is considered intermediate, like
# $(SOURCES)/%.tar.gz, for example.
.SECONDARY:
