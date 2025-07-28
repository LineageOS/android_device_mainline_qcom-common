#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196609
endif

# Firmware
PRODUCT_PACKAGES += \
    firmware_qcom_a530_pfp.fw \
    firmware_qcom_a530_pm4.fw

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8953.rc

# QRTR
PRODUCT_PACKAGES += \
    qrtr-cfg \
    qrtr-ns \
    qrtr-ns.rc
