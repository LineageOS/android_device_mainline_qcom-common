#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Firmware
LOCAL_FIRMWARE_GPU_A3XX := \
    firmware_qcom_a300_pfp.fw \
    firmware_qcom_a300_pm4.fw
LOCAL_FIRMWARE_GPU_A4XX := \
    firmware_qcom_a420_pfp.fw \
    firmware_qcom_a420_pm4.fw
ifneq ($(filter msm8916,$(TARGET_QCOM_SOC)),)
PRODUCT_PACKAGES += $(LOCAL_FIRMWARE_GPU_A3XX)
else ifneq ($(filter msm8929 msm8939 msm8939v2,$(TARGET_QCOM_SOC)),)
PRODUCT_PACKAGES += $(LOCAL_FIRMWARE_GPU_A4XX)
else
PRODUCT_PACKAGES += \
    $(LOCAL_FIRMWARE_GPU_A3XX) \
    $(LOCAL_FIRMWARE_GPU_A4XX)
endif
