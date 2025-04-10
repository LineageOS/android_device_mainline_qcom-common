#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Boot HAL
ifeq ($(AB_OTA_UPDATER),true)
TARGET_BOOT_HAL ?= qcom-caf-aidl
endif

# Inherit from mainline/common
include device/mainline/common/optional/options.mk
