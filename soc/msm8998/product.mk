#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Firmware
## Note: linux-firmware repo does not have a540_gpmu.fw2
PRODUCT_PACKAGES += \
    linux_firmware_qcom-a530

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196610
endif

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8998.rc

# Modem
PRODUCT_PACKAGES += \
    rmtfs \
    rmtfs.rc \
    tqftpserv \
    tqftpserv.rc

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.qcom.soc.enable_modem_services=1

# QRTR
PRODUCT_PACKAGES += \
    qrtr-cfg
