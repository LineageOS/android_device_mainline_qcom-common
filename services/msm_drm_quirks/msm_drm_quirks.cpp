/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

#include <cstring>
#include <string>

#define LOG_TAG "msm_drm_quirks"
#include <android-base/logging.h>
#include <android-base/properties.h>

#include <xf86drm.h>

extern "C" {
#include <freedreno_drmif.h>
}

using namespace android::base;

namespace {

const std::string kPropPrefix = "vendor.qcom.soc.msm_drm.";

int Work(struct fd_pipe* pipe) {
    uint64_t chip_id, gpu_id;

    fd_pipe_get_param(pipe, FD_CHIP_ID, &chip_id);
    fd_pipe_get_param(pipe, FD_GPU_ID, &gpu_id);
    LOG(INFO) << "chip_id = " << std::to_string(chip_id) << " gpu_id = " << std::to_string(gpu_id);
    SetProperty(kPropPrefix + "chip_id", std::to_string(chip_id));
    SetProperty(kPropPrefix + "gpu_id", std::to_string(gpu_id));

    return EXIT_SUCCESS;
}

}  // namespace

int main(int, char* argv[]) {
    struct fd_device* dev;
    struct fd_pipe* pipe;
    int fd, ret = EXIT_SUCCESS;

    InitLogging(argv, &KernelLogger);

    fd = open("/dev/dri/card0", O_RDWR);
    if (fd < 0) {
        LOG(ERROR) << "open() failed";
        goto err_open;
    }

    dev = fd_device_new(fd);
    if (!dev) {
        LOG(ERROR) << "fd_device_new() failed";
        goto err_fd_device_new;
    }

    pipe = fd_pipe_new(dev, FD_PIPE_3D);
    if (!pipe) {
        LOG(ERROR) << "fd_pipe_new() failed";
        goto err_fd_pipe_new;
    }

    ret = Work(pipe);

    fd_pipe_del(pipe);
err_fd_pipe_new:
    fd_device_del(dev);
err_fd_device_new:
    close(fd);
err_open:
    return ret;
}
