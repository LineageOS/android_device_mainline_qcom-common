#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_GRAPHICS),mesa)

PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.vulkan=freedreno \
    ro.opengles.version=196610

endif # TARGET_GRAPHICS
