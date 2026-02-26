#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_qcom-a630

# Graphics (Mesa)
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196610
endif

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.sdm670.rc
