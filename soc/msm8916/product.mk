#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
$(call soong_config_set,mainline_qcom_common_soc,primary_audio_policy_configuration_variant,msm8916)

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_qcom-a300 \
    linux_firmware_qcom-a420 \
    linux_firmware_qcom-venus-1.8

# Firmware symlinks
PRODUCT_PACKAGES += \
    mainline_qcom-common_symlink_persist_firmware_qcom_sensors_sns.reg \
    mainline_qcom-common_symlink_persist_firmware_wlan_prima_WCNSS_qcom_wlan_nv.bin

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8916.rc

# Modem
PRODUCT_PACKAGES += \
    rmtfs \
    rmtfs.rc
