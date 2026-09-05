#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_AUDIO_HAL),tinyhal)

$(call soong_config_set,tinyhal,in_period_size_default,480)
$(call soong_config_set,tinyhal,in_rate_default,48000)
$(call soong_config_set,tinyhal,out_period_size_default,480)
$(call soong_config_set,tinyhal,out_rate_default,48000)

endif # TARGET_AUDIO_HAL
