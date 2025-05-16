/*
 * FastRPC API Replacement
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

#include <libhexagonrpc/fastrpc.h>
#include <misc/fastrpc.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <stdio.h>

static void allocate_first_inbuf(const struct fastrpc_function_def_interp2 *def,
				 struct fastrpc_invoke_args *arg,
				 uint32_t **inbuf)
{
	uint32_t *buf;
	size_t len;

	len = sizeof(uint32_t) * (def->in_nums + def->in_bufs + def->out_bufs);

	if (len)
		buf = malloc(len);
	else
		buf = NULL;

	*inbuf = buf;

	if (buf != NULL) {
		arg->ptr = (__u64) buf;
		arg->length = len;
		arg->fd = -1;
	}
}

static void allocate_first_outbuf(const struct fastrpc_function_def_interp2 *def,
				  struct fastrpc_invoke_args *arg,
				  uint32_t **outbuf)
{
	uint32_t *buf;
	size_t len;

	len = sizeof(uint32_t) * def->out_nums;

	if (len)
		buf = malloc(len);
	else
		buf = NULL;

	*outbuf = buf;

	if (buf != NULL) {
		arg->ptr = (__u64) buf;
		arg->length = len;
		arg->fd = -1;
	}
}

/*
 * This populates relevant inputs (in general) with information necessary to
 * receive output from the remote processor.
 *
 * First, it allocates a new first output buffer to contain the returned 32-bit
 * integers. This output buffer must be freed after use.
 *
 * With a peek at the output arguments, it populates the fastrpc_invoke_args
 * struct to give information about the buffer to the kernel, and adds an entry
 * to the first input buffer to tell the remote processor how large the
 * function-level output buffer can be.
 *
 * This is the only part of the argument processing that can be split off into
 * a different function because it is operating on a copy of the va_list.
 * Calling va_arg() on a va_list after the return of a function that already
 * used it causes undefined behavior.
 */
static void prepare_outbufs(const struct fastrpc_function_def_interp2 *def,
			    struct fastrpc_invoke_args *args,
			    uint8_t out_count,
			    uint32_t *inbuf,
			    uint32_t **outbuf,
			    va_list peek)
{
	int i;
	int off;
	int size;

	allocate_first_outbuf(def, args, outbuf);

	off = def->out_nums && 1;

	for (i = 0; i < def->out_nums; i++)
		va_arg(peek, uint32_t *);

	for (i = 0; i < def->out_bufs; i++) {
		size = va_arg(peek, uint32_t);

		args[off + i].ptr = (__u64) va_arg(peek, void *);
		args[off + i].length = size;
		args[off + i].fd = -1;

		inbuf[i] = size;
	}
}

/*
 * This is the main function to invoke a fastrpc procedure call. The first
 * parameter specifies how to populate the ioctl-level buffers. The second and
 * third parameters specify where to send the invocation to. The fourth is the
 * list of arguments that the procedure call should interact with.
 *
 * The argument list has, in order:
 * - a (uint32_t val) for each input number
 * - a (uint32_t len, void *buf) for each input buffer
 * - a (uint32_t *val) for each output number
 * - a (uint32_t max_size, void *buf) for each output buffer
 *
 * A good example for this would be the adsp_listener_next2 call:
 *
 * static inline void adsp_listener_next2(int fd, uint32_t handle,
 *					  uint32_t prev_ctx,
 *					  uint32_t prev_result,
 *					  uint32_t nested_outbufs_len,
 *					  void *nested_outbufs,
 *					  uint32_t *ctx,
 *					  uint32_t *nested_handle,
 *					  uint32_t *nested_sc,
 *					  uint32_t *nested_inbufs_len,
 *					  uint32_t nested_inbufs_size,
 *					  void *nested_inbufs)
 * {
 *   struct fastrpc_function_def_interp2 def = {
 *     .in_nums = 2,
 *     .in_bufs = 1,
 *     .out_nums = 4,
 *     .out_bufs = 1,
 *     .mid = 4,
 *   };
 *   return fastrpc(def, fd, handle,
 *		    prev_ctx,
 *		    prev_result,
 *		    nested_outbufs_len,
 *		    nested_outbufs,
 *		    ctx,
 *		    nested_handle,
 *		    nested_sc,
 *		    nested_inbufs_len,
 *		    nested_inbufs_size,
 *		    nested_inbufs);
 * }
 */
int vfastrpc2(const struct fastrpc_function_def_interp2 *def,
	      int fd, uint32_t handle, va_list arg_list)
{
	va_list peek;
	struct fastrpc_invoke invoke;
	struct fastrpc_invoke_args *args;
	uint32_t *inbuf;
	uint32_t *outbuf;
	uint8_t in_count;
	uint8_t out_count;
	uint32_t size;
	uint8_t i;
	int ret;

	/*
	 * Calculate the amount of needed buffers, accounting for the need for
	 * the maximum size of the output buffer.
	 */
	in_count = def->in_bufs + ((def->in_nums
				 || def->in_bufs
				 || def->out_bufs) && 1);
	out_count = def->out_bufs + (def->out_nums && 1);

	if (in_count || out_count)
		args = malloc(sizeof(*args) * (in_count + out_count));
	else
		args = NULL;

	allocate_first_inbuf(def, args, &inbuf);

	for (i = 0; i < def->in_nums; i++)
		inbuf[i] = va_arg(arg_list, uint32_t);

	for (i = 0; i < def->in_bufs; i++) {
		size = va_arg(arg_list, uint32_t);

		args[i + 1].ptr = (__u64) va_arg(arg_list, void *);
		args[i + 1].length = size;
		args[i + 1].fd = -1;

		inbuf[def->in_nums + i] = size;
	}

	va_copy(peek, arg_list);
	prepare_outbufs(def,
			&args[in_count],
			out_count,
			&inbuf[def->in_nums + def->in_bufs],
			&outbuf,
			peek);
	va_end(peek);

	invoke.handle = handle;
	invoke.sc = REMOTE_SCALARS_MAKE(def->msg_id, in_count, out_count);
	invoke.args = (__u64) args;

	ret = ioctl(fd, FASTRPC_IOCTL_INVOKE, (__u64) &invoke);

	for (i = 0; i < def->out_nums; i++)
		*va_arg(arg_list, uint32_t *) = outbuf[i];

	if (in_count || out_count)
		free(args);

	if (in_count)
		free(inbuf);

	if (out_count)
		free(outbuf);

	return ret;
}

int fastrpc2(const struct fastrpc_function_def_interp2 *def,
	     int fd, uint32_t handle, ...)
{
	va_list arg_list;
	int ret;

	va_start(arg_list, handle);
	ret = vfastrpc2(def, fd, handle, arg_list);
	va_end(arg_list);

	return ret;
}
