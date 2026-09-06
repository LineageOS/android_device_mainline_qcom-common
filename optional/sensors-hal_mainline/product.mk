#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_SENSORS_HAL),mainline)

PRODUCT_VENDOR_PROPERTIES += \
    vendor.sensors.wait_for_sensors?=1 \
    vendor.sensors.wait_for_sensors_interval_ms?=1000 \
    vendor.sensors.wait_for_sensors_timeout_ms?=30000

_is_libssc_available := $(if $(wildcard external/libssc/Android.bp external/mainline-hw-deps/libssc/Android.bp),true,false)
$(call soong_config_set_bool,libsensors_libssc,enabled,$(_is_libssc_available))

ifeq ($(_is_libssc_available),true)
$(call soong_config_set_string_list,sensors_hal_mainline,include_custom_backends,//hardware/mainline/qcom:libsensors_libssc)
$(call soong_config_set,sensors_hal_mainline,load_custom_backends,libssc$(comma)iio)
endif # _is_libssc_available

endif # TARGET_SENSORS_HAL
