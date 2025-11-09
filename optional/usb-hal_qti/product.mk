#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_USB_HAL),qti)

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/usb/etc

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.usb.use_ffs_mtp=0 \
    vendor.usb.rndis.func.name=gsi \
    vendor.usb.rmnet.func.name=gsi \
    vendor.usb.rmnet.inst.name=rmnet \
    vendor.usb.dpl.inst.name=dpl \
    vendor.usb.qdss.inst.name=qdss_sw \
    vendor.usb.diag.func.name=diag

PRODUCT_VENDOR_PROPERTIES += \
    ro.usb.uvc.enabled=true

PRODUCT_PACKAGES += \
    init.qcom.usb.rc \
    init.qcom.usb.sh

PRODUCT_PACKAGES_DEBUG += \
    init.qcom.usb.debug.rc \
    init.qcom.usb.debug.sh

TARGET_USB_CONTROLLER ?= a600000.dwc3
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.usb.controller=$(TARGET_USB_CONTROLLER)

PRODUCT_PACKAGES += \
    android.hardware.usb-service.qti

endif # TARGET_USB_HAL
