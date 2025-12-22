#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
$(call soong_config_set,mainline_qcom_common_soc,primary_audio_policy_configuration_variant,sm8250)

# DSP
PRODUCT_PACKAGES += \
    hexagonrpcd_adsp_rootpd_phony \
    hexagonrpcd_adsp_sensorspd_phony

# Firmware
PRODUCT_PACKAGES += \
    firmware_ath11k_QCA6390_hw2.0_amss.bin \
    firmware_ath11k_QCA6390_hw2.0_board-2.bin \
    firmware_ath11k_QCA6390_hw2.0_m3.bin \
    linux_firmware_qcom-a650

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196610
endif

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.sm8250.rc

# QRTR
PRODUCT_PACKAGES += \
    qrtr-cfg \
    qrtr-ns \
    qrtr-ns.rc
