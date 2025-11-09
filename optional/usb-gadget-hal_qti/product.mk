#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_USB_GADGET_HAL),qti)

ifneq ($(TARGET_USB_HAL),qti)
$(error The qti usb gadget hal is only supported with the qti usb hal)
endif # TARGET_USB_HAL

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.usb.use_gadget_hal=1

PRODUCT_PACKAGES += \
    android.hardware.usb.gadget-service.qti \
    usb_compositions.conf

endif # TARGET_USB_GADGET_HAL
