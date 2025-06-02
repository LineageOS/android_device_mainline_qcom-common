#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_COPY_FILES += \
    $(MAINLINE_QCOM_COMMON_SOC_PATH)/audio/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml

# Firmware
PRODUCT_PACKAGES += \
    firmware_qcom_venus-1.8_venus.mbn

LOCAL_FIRMWARE_GPU_A3XX := \
    firmware_qcom_a300_pfp.fw \
    firmware_qcom_a300_pm4.fw
LOCAL_FIRMWARE_GPU_A4XX := \
    firmware_qcom_a420_pfp.fw \
    firmware_qcom_a420_pm4.fw
ifneq ($(filter msm8916 msm8916v2,$(TARGET_QCOM_SOC)),)
PRODUCT_PACKAGES += $(LOCAL_FIRMWARE_GPU_A3XX)
else ifneq ($(filter msm8929 msm8936 msm8939 msm8939v2 msm8939v3,$(TARGET_QCOM_SOC)),)
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
