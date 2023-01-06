/**
 *
 * Copyright (c) Roberto A. Foglietta, 2023
 *
 * Authors:
 *    Roberto A. Foglietta <roberto.foglietta@gmail.com>
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

//int isatty(int x) { x = 0; return 1; }
int isatty(int fd)  {
    int flags = fcntl(fd, F_GETFD);
    if (flags < 0) {
        errno = EBADF;
        return 0;
    }
    return 1;
}
