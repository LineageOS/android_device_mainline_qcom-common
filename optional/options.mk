#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Boot HAL
ifeq ($(AB_OTA_UPDATER),true)
TARGET_BOOT_HAL ?= qcom-caf-aidl
endif

# Graphics
## Use Swiftshader for SoCs where Mesa doesn't work properly (Adreno A5xx mostly)
ifneq ($(filter msm8953,$(TARGET_QCOM_SOC_FAMILY)),)
    TARGET_GRAPHICS ?= swiftshader
else ifneq ($(filter msm8937 msm8940 sdm439,$(TARGET_QCOM_SOC)),)
    TARGET_GRAPHICS ?= swiftshader
endif

# Inherit from mainline/common
include device/mainline/common/optional/options.mk
