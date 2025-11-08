#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_BOOT_HAL),qcom-caf-aidl)

PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

PRODUCT_SOONG_NAMESPACES += \
    hardware/qcom-caf/bootctrl

endif # TARGET_BOOT_HAL
