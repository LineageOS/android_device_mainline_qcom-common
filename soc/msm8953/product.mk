#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_COPY_FILES += \
    $(MAINLINE_QCOM_COMMON_SOC_PATH)/audio/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196609
endif

# Firmware
PRODUCT_PACKAGES += \
    firmware_qcom_a530_pfp.fw \
    firmware_qcom_a530_pm4.fw

# QRTR
PRODUCT_PACKAGES += \
    qrtr-ns \
    qrtr-ns.rc
