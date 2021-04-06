include config.mak

BUILD_PATH := $(PWD)/$(BUILD_DIR)
MUSL_PATH := $(PWD)/../musl-cross-make/output

ifeq ($(TARGET),x86_64)
	LINUX_HEADERS := /usr/src/linux-headers-5.4.0-70/include/
else
	LINUX_HEADERS := /usr/src/linux-raspi-headers-5.4.0-1023/include
endif
INCLUDE_DIRS := $(shell cd $(LINUX_HEADERS); for i in *; do echo $$i; done)

it: # the default goal {{{1

it:
	@printf '%s\n' 'BUILD_PATH $(BUILD_PATH)' 'TARGET $(TARGET)' \
		'LINUX_HEADERS $(LINUX_HEADERS)' 'INCLUDE_DIRS $(INCLUDE_DIRS)'
	#@sudo -E docker run -itv $(BUILD_PATH):/opt \
		-v $(MUSL_PATH)/bin:/home/test_user/bin \
		base bash

# su -l test_user
# cd /opt
# ./configure CC=x86_64-linux-musl-gcc
