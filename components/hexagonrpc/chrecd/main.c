/*
 * CHRE client daemon entry point
 *
 * Copyright (C) 2023 The Sensor Shell Contributors
 *
 * This file is part of sensh.
 *
 * Sensh is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <errno.h>
#include <libhexagonrpc/fastrpc.h>
#include <libhexagonrpc/interfaces/remotectl.def>
#include <libhexagonrpc/session.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "interfaces/chre_slpi.def"

/* TODO move these to libhexagonrpc since most clients use them */
static int remotectl_open(int fd, char *name, struct fastrpc_context **ctx, void (*err_cb)(const char *err))
{
	uint32_t handle;
	int32_t dlret;
	char err[256];
	int ret;

	ret = fastrpc2(&remotectl_open_def, fd, REMOTECTL_HANDLE,
		       strlen(name) + 1, name,
		       &handle,
		       &dlret,
		       256, err);

	if (ret == -1) {
		err_cb(strerror(errno));
		return ret;
	}

	if (dlret == -5) {
		err_cb(err);
		return dlret;
	}

	*ctx = fastrpc_create_context(fd, handle);

	return ret;
}

static int remotectl_close(struct fastrpc_context *ctx, void (*err_cb)(const char *err))
{
	uint32_t dlret;
	char err[256];
	int ret;

	ret = fastrpc2(&remotectl_close_def, ctx->fd, REMOTECTL_HANDLE,
		       ctx->handle,
		       &dlret,
		       256, err);

	if (ret == -1) {
		err_cb(strerror(errno));
		return ret;
	}

	fastrpc_destroy_context(ctx);

	return ret;
}

static void remotectl_err(const char *err)
{
	fprintf(stderr, "Could not remotectl: %s\n", err);
}

static int chre_slpi_start_thread(struct fastrpc_context *ctx)
{
	return fastrpc(&chre_slpi_start_thread_def, ctx);
}

static int chre_slpi_wait_on_thread_exit(struct fastrpc_context *ctx)
{
	return fastrpc(&chre_slpi_wait_on_thread_exit_def, ctx);
}

int main()
{
	struct fastrpc_context *ctx;
	int fd, ret;

	fd = hexagonrpc_fd_from_env();
	if (fd == -1)
		return 1;

	ret = remotectl_open(fd, "chre_slpi", &ctx, remotectl_err);
	if (ret)
		return 1;

	ret = chre_slpi_start_thread(ctx);
	if (ret) {
		fprintf(stderr, "Could not start CHRE\n");
		goto err;
	}

	ret = chre_slpi_wait_on_thread_exit(ctx);
	if (ret) {
		fprintf(stderr, "Could not wait for CHRE thread\n");
		goto err;
	}

err:
	remotectl_close(ctx, remotectl_err);
}
