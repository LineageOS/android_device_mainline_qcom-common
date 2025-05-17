#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Firmware
LOCAL_FIRMWARE_GPU_A3XX := \
    firmware_qcom_a300_pfp.fw \
    firmware_qcom_a300_pm4.fw
LOCAL_FIRMWARE_GPU_A5XX := \
    firmware_qcom_a530_pfp.fw \
    firmware_qcom_a530_pm4.fw
ifneq ($(filter qcm2150 qm215 msm8917 msm8920,$(TARGET_QCOM_SOC)),)
PRODUCT_PACKAGES += $(LOCAL_FIRMWARE_GPU_A3XX)
else ifneq ($(filter msm8937 msm8940 sdm429 sdm439,$(TARGET_QCOM_SOC)),)
PRODUCT_PACKAGES += $(LOCAL_FIRMWARE_GPU_A5XX)
else
PRODUCT_PACKAGES += \
    $(LOCAL_FIRMWARE_GPU_A3XX) \
    $(LOCAL_FIRMWARE_GPU_A5XX)
endif

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8937.rc
