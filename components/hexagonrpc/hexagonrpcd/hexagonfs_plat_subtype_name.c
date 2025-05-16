/*
 * HexagonFS operations for a missing sysfs file
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
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

#include "hexagonfs.h"

struct plat_subtype_ctx {
	int fd;
	char *name;
};

static void plat_subtype_name_close(void *fd_data)
{
	struct plat_subtype_ctx *ctx = fd_data;

	close(ctx->fd);

	if (ctx->name != NULL)
		free(ctx->name);
}

static int plat_subtype_name_from_dirent(const void *dirent_data,
					 bool dir,
					 void **fd_data)
{
	struct plat_subtype_ctx *ctx;

	if (dir)
		return -ENOTDIR;

	ctx = malloc(sizeof(struct plat_subtype_ctx));
	if (ctx == NULL)
		return -ENOMEM;

	ctx->fd = open(dirent_data, O_RDONLY);
	if (ctx->fd == -1)
		return -errno;

	ctx->name = NULL;

	*fd_data = ctx;

	return 0;
}

static int plat_subtype_name_openat(struct hexagonfs_fd *dir,
			const char *segment,
			bool expect_dir,
			struct hexagonfs_fd **out)
{
	return -ENOTDIR;
}

static int plat_subtype_stat(struct hexagonfs_fd *fd, struct stat *stats)
{
	stats->st_size = 0;

	stats->st_dev = 0;
	stats->st_rdev = 0;

	stats->st_ino = 0;
	stats->st_nlink = 0;

	stats->st_mode = S_IFREG | S_IRUSR | S_IRGRP | S_IROTH;

	stats->st_atim.tv_sec = 0;
	stats->st_atim.tv_nsec = 0;
	stats->st_ctim.tv_sec = 0;
	stats->st_ctim.tv_nsec = 0;
	stats->st_mtim.tv_sec = 0;
	stats->st_mtim.tv_nsec = 0;

	return 0;
}

struct hexagonfs_file_ops hexagonfs_plat_subtype_name_ops = {
	.close = plat_subtype_name_close,
	.from_dirent = plat_subtype_name_from_dirent,
	.openat = plat_subtype_name_openat,
	.stat = plat_subtype_stat,
};
