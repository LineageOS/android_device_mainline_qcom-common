#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_COPY_FILES += \
    $(MAINLINE_QCOM_COMMON_PATH)/soc/sm7150/audio/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml

# DSP
PRODUCT_PACKAGES += \
    hexagonrpcd-adsp-rootpd.rc \
    hexagonrpcd-adsp-sensorspd.rc

# Firmware
PRODUCT_PACKAGES += \
    firmware_qcom_a630_gmu.bin \
    firmware_qcom_a630_sqe.fw

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.sm7150.rc
