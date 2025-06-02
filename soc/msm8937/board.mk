#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
ifeq ($(TARGET_CPU_VARIANT_RUNTIME_ENABLE),true)
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a53
else
TARGET_CPU_VARIANT := cortex-a53
endif

ifneq ($(TARGET_SUPPORTS_32_BIT_APPS),false)
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
ifeq ($(TARGET_CPU_VARIANT_RUNTIME_ENABLE),true)
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a53
else
TARGET_2ND_CPU_VARIANT := cortex-a53
endif
endif

# Bootloader (lk2nd)
TARGET_LK2ND_PLATFORM := msm8952

# Boot parameters
MAINLINE_QCOM_SOC_ANDROIDBOOT_PARAMS := \
    androidboot.boot_devices=soc@0/7824900.mmc

# Kernel
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x01000000 --tags_offset 0x00000100

# Partitions
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

# Properties
TARGET_VENDOR_PROP += \
    $(MAINLINE_QCOM_COMMON_SOC_PATH)/properties/vendor.prop
