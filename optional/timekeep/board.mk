#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_USES_TIMEKEEP),true)

include hardware/sony/timekeep/sepolicy/SEPolicy.mk

endif # TARGET_USES_TIMEKEEP
