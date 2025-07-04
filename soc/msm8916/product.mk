#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Firmware
PRODUCT_PACKAGES += \
    firmware_qcom_venus-1.8_venus.mbn

LOCAL_FIRMWARE_GPU_A3XX := \
    firmware_qcom_a300_pfp.fw \
    firmware_qcom_a300_pm4.fw
LOCAL_FIRMWARE_GPU_A4XX := \
    firmware_qcom_a420_pfp.fw \
    firmware_qcom_a420_pm4.fw
ifneq ($(filter msm8916%,$(TARGET_QCOM_SOC)),)
PRODUCT_PACKAGES += $(LOCAL_FIRMWARE_GPU_A3XX)
else ifneq ($(filter msm8929 msm8936 msm8939%,$(TARGET_QCOM_SOC)),)
PRODUCT_PACKAGES += $(LOCAL_FIRMWARE_GPU_A4XX)
else
PRODUCT_PACKAGES += \
    $(LOCAL_FIRMWARE_GPU_A3XX) \
    $(LOCAL_FIRMWARE_GPU_A4XX)
endif

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8916.rc

# Modem
PRODUCT_PACKAGES += \
    rmtfs \
    rmtfs.rc
