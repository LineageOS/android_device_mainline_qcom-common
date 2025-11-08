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
PRODUCT_COPY_FILES += \
    $(MAINLINE_QCOM_COMMON_PATH)/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Mountpoint
PRODUCT_PACKAGES += \
    mainline_qcom-common_vendor_dsp_mountpoint \
    mainline_qcom-common_vendor_firmware_gen_mountpoint \
    mainline_qcom-common_vendor_firmware_mnt_mountpoint

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(MAINLINE_QCOM_COMMON_PATH)/overlays/overlay

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.qcom.soc.family=$(TARGET_QCOM_SOC_FAMILY)

# Recovery
PRODUCT_PACKAGES += \
    init.recovery.mainline.qcom.rc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(MAINLINE_QCOM_COMMON_PATH)

# Time
PRODUCT_PACKAGES += \
    TimeKeep

# Utilities
PRODUCT_PACKAGES += \
    pil-squasher

# Wi-Fi
MAINLINE_QCOM_WIFI_CONFIGS ?= \
    wpa_supplicant.conf

PRODUCT_PACKAGES += \
    $(MAINLINE_QCOM_WIFI_CONFIGS)
