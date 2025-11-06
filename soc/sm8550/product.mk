#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
$(call soong_config_set,mainline_qcom_common_soc,primary_audio_policy_configuration_variant,sm7150)

# DSP
PRODUCT_PACKAGES += \
    hexagonrpcd_adsp_rootpd_phony

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_ath12k-wcn7850

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196610
endif

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.sm8550.rc
