#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_GRAPHICS),swiftshader)

ifeq ($(TARGET_GRAPHICS_ALLOCATOR_HAL),minigbm)
PRODUCT_VENDOR_PROPERTIES += \
    vendor.minigbm.debug=nocompression
else ifeq ($(TARGET_GRAPHICS_ALLOCATOR_HAL),minigbm-upstream)
PRODUCT_VENDOR_PROPERTIES += \
    vendor.minigbm.debug=nocompression
endif # TARGET_GRAPHICS_ALLOCATOR_HAL

endif # TARGET_GRAPHICS
