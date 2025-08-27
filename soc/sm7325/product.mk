#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_COPY_FILES += \
    $(MAINLINE_QCOM_COMMON_SOC_PATH)/audio/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml

# DSP
PRODUCT_PACKAGES += \
    hexagonrpcd_adsp_rootpd_phony \
    hexagonrpcd_adsp_sensorspd_phony

# Firmware
PRODUCT_PACKAGES += \
    firmware_ath11k_WCN6750_hw1.0_board-2.bin \
    firmware_ath11k_WCN6750_hw1.0_sc7280_wpss.mbn \
    firmware_qcom_a660_gmu.bin \
    firmware_qcom_a660_sqe.fw \
    firmware_qcom_sm7325_a660_zap.mbn

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196610
endif

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.sm7325.rc

# Modem
PRODUCT_PACKAGES += \
    rmtfs \
    rmtfs.rc \
    tqftpserv \
    tqftpserv.rc

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.qcom.soc.enable_modem_services=1

# QRTR
PRODUCT_PACKAGES += \
    qrtr-cfg \
    qrtr-ns \
    qrtr-ns.rc
