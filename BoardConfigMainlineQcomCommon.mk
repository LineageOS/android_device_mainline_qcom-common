#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

USES_DEVICE_MAINLINE_QCOM_COMMON := true

# Inherit from mainline/common
include device/mainline/common/BoardConfigMainlineCommon.mk

# Include the fragments
-include $(MAINLINE_QCOM_COMMON_PATH)/optional/*/board.mk
include $(MAINLINE_QCOM_COMMON_PATH)/soc/$(TARGET_QCOM_SOC_FAMILY)/board.mk

# Bootloader (lk2nd)
TARGET_LK2ND_ACTUAL_BOOTIMG_OFFSET ?= 524288

# Boot parameters
MAINLINE_QCOM_KERNEL_PARAMS := \
    console=ttyMSM0,115200n8

# Graphics (Mesa)
BOARD_MESA3D_GALLIUM_DRIVERS += freedreno
BOARD_MESA3D_VULKAN_DRIVERS += freedreno

# Properties
TARGET_PRODUCT_PROP += \
    $(MAINLINE_QCOM_COMMON_PATH)/properties/product.prop

TARGET_VENDOR_PROP += \
    $(MAINLINE_QCOM_COMMON_PATH)/properties/vendor.prop \
    $(MAINLINE_QCOM_COMMON_PATH)/properties/vendor_bluetooth.prop

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT ?= RGBX_8888

# SELinux
include hardware/sony/timekeep/sepolicy/SEPolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(MAINLINE_QCOM_COMMON_PATH)/sepolicy/vendor
