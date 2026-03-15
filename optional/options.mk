#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# SoC - keep this on top
ifeq ($(TARGET_QCOM_SOC_FAMILY),)
    ifeq ($(TARGET_QCOM_SOC),)
        $(error Please define either TARGET_QCOM_SOC or TARGET_QCOM_SOC_FAMILY)
    else
        ifneq ($(filter msm8916% msm8929 msm8936 msm8939%,$(TARGET_QCOM_SOC)),)
            TARGET_QCOM_SOC_FAMILY := msm8916
        else ifneq ($(filter msm8917 msm8920 msm8937 msm8940 qcm2150 qm215 sdm429 sdm439,$(TARGET_QCOM_SOC)),)
            TARGET_QCOM_SOC_FAMILY := msm8937
        else ifneq ($(filter msm8953% sdm450 sdm632,$(TARGET_QCOM_SOC)),)
            TARGET_QCOM_SOC_FAMILY := msm8953
        else ifneq ($(filter sdm670 sdm710,$(TARGET_QCOM_SOC)),)
            TARGET_QCOM_SOC_FAMILY := sdm670
        else ifneq ($(filter sm7150%,$(TARGET_QCOM_SOC)),)
            TARGET_QCOM_SOC_FAMILY := sm7150
        else ifneq ($(filter qcs8550,$(TARGET_QCOM_SOC)),)
            TARGET_QCOM_SOC_FAMILY := sm8550
        else ifneq ($(filter cq8725s cq8750s,$(TARGET_QCOM_SOC)),)
            TARGET_QCOM_SOC_FAMILY := sm8750
        else
            $(error Please add the SoC to this section)
        endif
    endif
endif

ifneq ($(filter apq% msm%,$(TARGET_QCOM_SOC_FAMILY)),)
TARGET_QCOM_SOC_FAMILY_IS_LEGACY := true
endif

# Audio HAL
ifneq ($(TARGET_INITIAL_BRINGUP),true)
TARGET_AUDIO_HAL ?= tinyhal
endif

# Boot HAL
ifeq ($(AB_OTA_UPDATER),true)
TARGET_BOOT_HAL ?= qcom-caf-aidl
endif

# Graphics HALs
TARGET_GRAPHICS_ALLOCATOR_HAL ?= minigbm-upstream

# Inherit from mainline/common
include device/mainline/common/optional/options.mk

##### Do not add statements below the inherit in above unless necessary #####
