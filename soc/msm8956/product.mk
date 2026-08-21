#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
$(call soong_config_set,mainline_qcom_common_soc,primary_audio_policy_configuration_variant,msm8916)

# Bluetooth
PRODUCT_VENDOR_PROPERTIES += bluetooth.le.disable_apcf_extended_features?=1

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_qcom-a530

# Firmware symlinks
PRODUCT_PACKAGES += \
    mainline_qcom-common_symlink_persist_firmware_qcom_sensors_sns.reg \
    mainline_qcom-common_symlink_persist_firmware_wlan_prima_WCNSS_qcom_wlan_nv.bin

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196609
endif

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8956.rc
