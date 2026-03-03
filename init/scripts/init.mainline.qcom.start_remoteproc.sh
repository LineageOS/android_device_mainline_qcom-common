#!/vendor/bin/sh
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOG_TAG="start_remoteproc.sh"
PROP_PREFIX="vendor.remoteproc"
TRIGGER_START_PROP="${PROP_PREFIX}.trigger_start"

function echo_log() {
    echo "${LOG_TAG}: $@"
}

function get_remoteproc_prop() {
    getprop "${PROP_PREFIX}.${1}.${2}"
}

function set_remoteproc_prop() {
    setprop "${PROP_PREFIX}.${1}.${2}" ${3}
}

cd /sys/class/remoteproc || (echo_log "Failed to enter /sys/class/remoteproc"; exit 1)

START_SINGLE_REMOTEPROC=$1
if [ "$START_SINGLE_REMOTEPROC" ]; then
    START_SINGLE_REMOTEPROC_DONE=0
    echo_log "Start remoteproc ${START_SINGLE_REMOTEPROC} on request"
fi

for rproc in `ls`; do
    rproc_name=$(cat ${rproc}/name|sed 's|\.|_|g')
    rproc_realpath=$(realpath ${rproc})

    if [ "$START_SINGLE_REMOTEPROC" ]; then
        if [ "${rproc_name}" != "$START_SINGLE_REMOTEPROC" ]; then
            continue
        fi
    else
        echo_log "Found remoteproc ${rproc_name}: ${rproc_realpath}"
    fi

    if [ "$(get_remoteproc_prop ${rproc_name} ignore)" = "1" ] && [ -z "$START_SINGLE_REMOTEPROC" ]; then
        echo_log "Remoteproc ${rproc_name} is ignored by property"
        continue;
    fi

    rproc_prop_recovery=$(get_remoteproc_prop ${rproc_name} recovery)
    if [ "$rproc_prop_recovery" ]; then
        echo_log "Set remoteproc ${rproc_name} recovery to: ${rproc_prop_recovery}"
        echo "${rproc_prop_recovery}" > ${rproc}/recovery
    fi

    rproc_state=$(cat ${rproc}/state)
    if [ "$rproc_state" = "running" ]; then
        echo_log "Remoteproc ${rproc_name} is already running"
        set_remoteproc_prop ${rproc_name} is_started 1
        continue
    fi

    rproc_prop_firmware=$(get_remoteproc_prop ${rproc_name} firmware)
    if [ "$rproc_prop_firmware" ]; then
        echo_log "Set remoteproc ${rproc_name} firmware to: ${rproc_prop_firmware}"
        echo "${rproc_prop_firmware}" > ${rproc}/firmware
    fi

    echo_log "Triggering start of remoteproc ${rproc_name}"
    echo "start" > ${rproc}/state
    start_ret=$?
    echo_log "Finished triggering start of remoteproc ${rproc_name}, return code is ${start_ret}"
    if [ $start_ret -eq 0 ]; then
        set_remoteproc_prop ${rproc_name} is_started 1
    else
        set_remoteproc_prop ${rproc_name} is_started 0
    fi

    if [ "$START_SINGLE_REMOTEPROC" ]; then
        START_SINGLE_REMOTEPROC_DONE=1
        break
    fi
done

if [ "$START_SINGLE_REMOTEPROC" ] && [ "$START_SINGLE_REMOTEPROC_DONE" != "1" ]; then
    echo_log "Unable to find the remoteproc that was requested to start: $START_SINGLE_REMOTEPROC"
fi

exit 0
