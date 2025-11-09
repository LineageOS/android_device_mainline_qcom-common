#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_USB_INIT_SCRIPT),qti)

PRODUCT_PACKAGES += \
    init.qcom.usb.rc \
    init.qcom.usb.sh

PRODUCT_PACKAGES_DEBUG += \
    init.qcom.usb.debug.rc \
    init.qcom.usb.debug.sh

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/usb/etc

# Enable MTP over FFS (for kernel version > 4.19)
PRODUCT_VENDOR_PROPERTIES += \
    sys.usb.mtp.batchcancel=1 \
    vendor.usb.use_ffs_mtp=1

# USB Gadget functions that exists on mainline kernel
PRODUCT_VENDOR_PROPERTIES += \
    vendor.usb.rndis.func.name=rndis

ifdef TARGET_USB_GADGET_HAL
PRODUCT_VENDOR_PROPERTIES += \
    vendor.usb.use_gadget_hal=1
else
PRODUCT_VENDOR_PROPERTIES += \
    vendor.usb.use_gadget_hal=0
endif

endif # TARGET_USB_INIT_SCRIPT
