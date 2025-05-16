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

#ifndef LIBHEXAGONRPC_SESSION_H
#define LIBHEXAGONRPC_SESSION_H

/*
 * Get the file descriptor from the environment variables. Due to its
 * usage of getenv, it is not thread-safe.
 *
 * On success, returns the file descriptor. On failure, returns -1.
 */
int hexagonrpc_fd_from_env(void);

#endif /* LIBHEXAGONRPC_SESSION_H */
