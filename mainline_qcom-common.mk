#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

MAINLINE_QCOM_COMMON_PATH := device/mainline/qcom-common
MAINLINE_QCOM_COMMON_SOC_PATH := $(MAINLINE_QCOM_COMMON_PATH)/soc/$(TARGET_QCOM_SOC_FAMILY)

# Inherit from mainline/common
$(call inherit-product, device/mainline/common/mainline_common.mk)

# Include the fragments
include $(MAINLINE_QCOM_COMMON_PATH)/optional/*/product.mk
include $(MAINLINE_QCOM_COMMON_SOC_PATH)/product.mk

# Build environment
ifeq ($(wildcard hardware/qcom-caf/common/Android.bp),)
$(call soong_config_set_bool,mainline_qcom_common,path_hardware_qcom_caf_common_is_absent,true)
endif

# Graphics
PRODUCT_PACKAGES += \
    msm_drm_quirks

# Graphics allocator (minigbm)
TARGET_MINIGBM_PLATFORM := msm

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.rc

PRODUCT_PACKAGES += \
    init.mainline.qcom.sh

# Media
PRODUCT_PACKAGES += \
    media_profiles.xml

# Mountpoint
ifeq ($(SOONG_CONFIG_mainline_qcom_common_path_hardware_qcom_caf_common_is_absent),true)
PRODUCT_PACKAGES += \
    mainline_qcom-common_vendor_dsp_mountpoint \
    mainline_qcom-common_vendor_firmware_mnt_mountpoint
else
PRODUCT_PACKAGES += \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint
endif

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(MAINLINE_QCOM_COMMON_PATH)/overlays/overlay

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.qcom.soc.family=$(TARGET_QCOM_SOC_FAMILY)

ifneq ($(TARGET_QCOM_SOC_FAMILY_IS_LEGACY),true)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.surface_flinger.supports_background_blur=1
endif
endif

# Recovery
PRODUCT_PACKAGES += \
    init.recovery.mainline.qcom.rc

# SoC-specific
PRODUCT_PACKAGES += \
    mainline_qcom-common_soc_phony

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(MAINLINE_QCOM_COMMON_PATH) \
    hardware/mainline/qcom

# Time
PRODUCT_PACKAGES += \
    com.sony.timekeep.apex

# Utilities
PRODUCT_PACKAGES += \
    pil-squasher
