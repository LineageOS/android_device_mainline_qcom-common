#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(USES_DEVICE_MAINLINE_QCOM_COMMON),true)

# lk2nd
LK2ND_SOURCE := external/lk2nd
ifneq ($(wildcard $(LK2ND_SOURCE)/makefile),)
INSTALLED_LK2NDIMAGE_TARGET := $(PRODUCT_OUT)/lk2nd.img
endif

endif # USES_DEVICE_MAINLINE_QCOM_COMMON
