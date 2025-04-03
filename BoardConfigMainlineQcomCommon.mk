#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

USES_DEVICE_MAINLINE_QCOM_COMMON := true

# Inherit from mainline/common
include device/mainline/common/BoardConfigMainlineCommon.mk

# Include the fragments
-include $(MAINLINE_QCOM_COMMON_PATH)/optional/*/board.mk

# Boot parameters
MAINLINE_QCOM_KERNEL_PARAMS := \
    console=ttyMSM0,115200n8

# Graphics (Mesa)
BOARD_MESA3D_GALLIUM_DRIVERS += freedreno
BOARD_MESA3D_VULKAN_DRIVERS += freedreno

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT ?= RGBX_8888
