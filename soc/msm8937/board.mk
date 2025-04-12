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
