#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
ifeq ($(TARGET_CPU_VARIANT_RUNTIME_ENABLE),true)
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a55
else
TARGET_CPU_VARIANT := cortex-a55
endif

ifneq ($(TARGET_SUPPORTS_32_BIT_APPS),false)
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
ifeq ($(TARGET_CPU_VARIANT_RUNTIME_ENABLE),true)
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55
else
TARGET_2ND_CPU_VARIANT := cortex-a55
endif
endif

# Boot parameters
MAINLINE_QCOM_SOC_ANDROIDBOOT_PARAMS := \
    androidboot.boot_devices=soc@0/1d84000.ufshc

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(MAINLINE_QCOM_COMMON_PATH)/soc/sm7150/sepolicy/vendor
