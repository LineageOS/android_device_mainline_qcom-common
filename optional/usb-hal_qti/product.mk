#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_USB_HAL),qti)
PRODUCT_PACKAGES += android.hardware.usb-service.qti
endif # TARGET_USB_HAL
