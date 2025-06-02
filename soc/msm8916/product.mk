#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_COPY_FILES += \
    $(MAINLINE_QCOM_COMMON_SOC_PATH)/audio/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_qcom-a300 \
    linux_firmware_qcom-a420 \
    linux_firmware_qcom-venus-1.8

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8916.rc

# Modem
PRODUCT_PACKAGES += \
    rmtfs \
    rmtfs.rc
