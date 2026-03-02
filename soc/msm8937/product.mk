#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
$(call soong_config_set,mainline_qcom_common_soc,primary_audio_policy_configuration_variant,msm8916)

# Bluetooth
ifeq ($(filter qcm2150 qm215 sdm429 sdm439,$(TARGET_QCOM_SOC)),)
PRODUCT_VENDOR_PROPERTIES += bluetooth.le.disable_apcf_extended_features?=1
endif

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_qcom-a300 \
    linux_firmware_qcom-a530

# Firmware symlinks
PRODUCT_PACKAGES += \
    mainline_qcom-common_symlink_persist_firmware_qcom_sensors_sns.reg \
    mainline_qcom-common_symlink_persist_firmware_wlan_prima_WCNSS_qcom_wlan_nv.bin

# Graphics
PRODUCT_PACKAGES += \
    msm_drm_quirks

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8937.rc
