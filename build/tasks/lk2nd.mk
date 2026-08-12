#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(USES_DEVICE_MAINLINE_QCOM_COMMON),true)
ifneq ($(wildcard $(LK2ND_SOURCE)/makefile),)
ifneq ($(TARGET_LK2ND_PLATFORM),)

LK2ND_MAKE_CMD := $(BUILD_TOP)/prebuilts/build-tools/$(HOST_PREBUILT_TAG)/bin/make
LK2ND_OUT_DIR := $(TARGET_OUT_INTERMEDIATES)/LK2ND_OBJ
LK2ND_PATH_OVERRIDE := PATH=$(BUILD_TOP)/prebuilts/tools-lineage/$(HOST_PREBUILT_TAG)/bin:$(BUILD_TOP)/prebuilts/kernel-build-tools/linux-x86/bin:$$PATH

LK2ND_MAKE_FLAGS := \
    -C $(LK2ND_SOURCE) \
    -j$(shell getconf _NPROCESSORS_ONLN) \
    BOOTLOADER_OUT=$(BUILD_TOP)/$(LK2ND_OUT_DIR) \
    DTC=$(BUILD_TOP)/$(HOST_OUT_EXECUTABLES)/dtc \
    TOOLCHAIN_PREFIX=/usr/bin/arm-none-eabi- \
    $(TARGET_LK2ND_MAKE_FLAGS)

$(INSTALLED_LK2NDIMAGE_TARGET): $(HOST_OUT_EXECUTABLES)/dtc
	$(call pretty,"Target lk2nd image: $@")
	mkdir -p $(LK2ND_OUT_DIR)
	$(LK2ND_PATH_OVERRIDE) $(LK2ND_MAKE_CMD) $(strip $(LK2ND_MAKE_FLAGS)) lk2nd-$(TARGET_LK2ND_PLATFORM)
	cp $(LK2ND_OUT_DIR)/build-lk2nd-$(TARGET_LK2ND_PLATFORM)/lk2nd.img $@

.PHONY: lk2nd
lk2nd: $(INSTALLED_LK2NDIMAGE_TARGET)

endif # TARGET_LK2ND_PLATFORM
endif # $(LK2ND_SOURCE)/makefile
endif # USES_DEVICE_MAINLINE_QCOM_COMMON
