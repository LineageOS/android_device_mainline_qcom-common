#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_GRAPHICS),mesa)

ifneq ($(TARGET_QCOM_SOC_FAMILY_IS_LEGACY),true)
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.vulkan=freedreno \
    ro.opengles.version?=196610
endif

endif # TARGET_GRAPHICS
