#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_USB_GADGET_HAL),qti)

ifneq ($(TARGET_USB_INIT_SCRIPT),qti)
$(error TARGET_USB_GADGET_HAL=qti depends on TARGET_USB_INIT_SCRIPT=qti)
endif

PRODUCT_PACKAGES += \
    android.hardware.usb.gadget-service.qti \
    usb_compositions.conf

endif # TARGET_USB_GADGET_HAL
