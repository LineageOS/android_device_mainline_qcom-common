#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

MAINLINE_QCOM_COMMON_PATH := device/mainline/qcom-common

# Inherit from mainline/common
$(call inherit-product, device/mainline/common/mainline_common.mk)

# Include the fragments
include $(MAINLINE_QCOM_COMMON_PATH)/optional/*/product.mk
include $(MAINLINE_QCOM_COMMON_PATH)/soc/$(TARGET_QCOM_SOC_FAMILY)/product.mk

# Graphics allocator (minigbm)
TARGET_MINIGBM_HAL_INTERFACE := hidl
TARGET_MINIGBM_PLATFORM := msm

# Init
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,init.mainline.qcom.*,$(MAINLINE_QCOM_COMMON_PATH)/init/,$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/)

# Mountpoint
PRODUCT_PACKAGES += \
    vendor_firmware_mnt_mountpoint

# Recovery
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,init.recovery.mainline.qcom.*,$(MAINLINE_QCOM_COMMON_PATH)/init/,$(TARGET_COPY_OUT_RECOVERY)/root/)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(MAINLINE_QCOM_COMMON_PATH)
