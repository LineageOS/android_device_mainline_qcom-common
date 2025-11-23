#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
$(call soong_config_set,mainline_qcom-common_soc,primary_audio_policy_configuration_variant,msm8953)

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196609
endif

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_qcom-a530

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8953.rc

# QRTR
PRODUCT_PACKAGES += \
    qrtr-cfg \
    qrtr-ns \
    qrtr-ns.rc
