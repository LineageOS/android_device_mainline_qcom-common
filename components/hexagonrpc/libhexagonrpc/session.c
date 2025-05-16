/*
 * FastRPC API Replacement - API for session-managed clients
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

#include <stdint.h>
#include <stdlib.h>

int hexagonrpc_fd_from_env(void)
{
	const char *fd_str;
	char *num_end;
	long fd;

	fd_str = getenv("HEXAGONRPC_FD");
	if (fd_str == NULL)
		return -1;

	fd = strtol(fd_str, &num_end, 10);
	if (fd != (int) fd || fd < 0 || *num_end != '\0')
		return -1;

	return fd;
}
