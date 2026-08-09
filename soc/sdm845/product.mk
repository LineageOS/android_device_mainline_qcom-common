##
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_COPY_FILES += \
    $(MAINLINE_QCOM_COMMON_SOC_PATH)/audio/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml

# DSP
PRODUCT_PACKAGES += \
    hexagonrpcd_adsp_rootpd_phony \
    hexagonrpcd_adsp_sensorspd_phony

# Firmware (Adreno 630 + WCN3990 + crnv21)
PRODUCT_PACKAGES += \
    firmware_ath10k_WCN3990_hw1.0_board-2.bin \
    firmware_ath10k_WCN3990_hw1.0_firmware-5.bin \
    linux_firmware_qcom-a630 \
    firmware_qca_crnv21.bin

# Graphics (Mesa / Freedreno)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196610
endif

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.sdm845.rc

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
    qrtr-cfg