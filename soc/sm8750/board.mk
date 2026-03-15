#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Architecture
TARGET_ARCH := arm64
# Clang assumes that ARMv9-A chips always implement SVE2, but SM8750 does not
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
ifeq ($(TARGET_CPU_VARIANT_RUNTIME_ENABLE),true)
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := oryon
else # !TARGET_CPU_VARIANT_RUNTIME_ENABLE
TARGET_CPU_VARIANT := oryon
endif # TARGET_CPU_VARIANT_RUNTIME_ENABLE

# Boot parameters
MAINLINE_QCOM_SOC_ANDROIDBOOT_PARAMS := \
    androidboot.boot_devices=soc@0/1d84000.ufshc

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(MAINLINE_QCOM_COMMON_SOC_PATH)/sepolicy/vendor
