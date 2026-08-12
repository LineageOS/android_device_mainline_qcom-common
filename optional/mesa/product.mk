#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_GRAPHICS),mesa)

ifneq ($(TARGET_QCOM_SOC_FAMILY_IS_LEGACY),true)
TARGET_USES_VULKAN := true

PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.vulkan=freedreno
endif

endif # TARGET_GRAPHICS
