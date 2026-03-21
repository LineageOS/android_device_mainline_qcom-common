#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
$(call soong_config_set,mainline_qcom_common_soc,primary_audio_policy_configuration_variant,sm8550)

# Bluetooth
ifneq ($(TARGET_BLUETOOTH_HAL),)
PRODUCT_PACKAGES += \
    android.hardware.bluetooth_le.prebuilt.xml
endif

# DSP
PRODUCT_PACKAGES += \
    hexagonrpcd_adsp_rootpd_phony

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_ath12k-wcn7850

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2025-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2025-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196610
endif

# Graphics allocator (minigbm)
$(call soong_config_set_string_list,minigbm_upstream,cflags,-DSC_7280)

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.sm8550.rc

# Media
ifeq ($(TARGET_MEDIA_C2_HAL),v4l2_codec2)
PRODUCT_COPY_FILES += \
    $(MAINLINE_QCOM_COMMON_SOC_PATH)/media/media_codecs_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2.xml

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.v4l2_codec2.decode_concurrent_instances=16 \
    ro.vendor.v4l2_codec2.encode_concurrent_instances=16

PRODUCT_VENDOR_PROPERTIES += \
    debug.stagefright.c2-poolmask=0x1f50000

TARGET_V4L2_CODEC2_USE_EXAMPLE_CONFIGURATION := false
endif # TARGET_MEDIA_C2_HAL

# Thermal
ifeq ($(TARGET_THERMAL_HAL),linaro-libpm)
PRODUCT_PACKAGES += \
    thermal-sm8550.json

PRODUCT_VENDOR_PROPERTIES += \
    vendor.thermal.config=thermal-sm8550.json
endif # TARGET_THERMAL_HAL
