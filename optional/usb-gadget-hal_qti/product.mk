#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_USB_GADGET_HAL),qti)
PRODUCT_PACKAGES += android.hardware.usb.gadget-service.qti
endif # TARGET_USB_GADGET_HAL
