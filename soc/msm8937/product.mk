#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
$(call soong_config_set,mainline_qcom_common_soc,primary_audio_policy_configuration_variant,msm8916)

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_qcom-a300 \
    linux_firmware_qcom-a530

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8937.rc
