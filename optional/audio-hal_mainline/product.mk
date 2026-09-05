#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_AUDIO_HAL),mainline)

PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.mainline.cards?=0 \
    vendor.audio.mainline.card.0.bits?=16 \
    vendor.audio.mainline.card.0.rates?=48000 \
    vendor.audio.mainline.wait_for_cards_ms?=30000

endif # TARGET_AUDIO_HAL
