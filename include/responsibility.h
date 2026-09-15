/*
 * <responsibility.h> -- the process responsibility SPI system_cmds' gcore
 * uses to record which process is responsible for the one it dumps.
 *
 * Apple publish no copy of this header; libquarantine's SDK stub exports
 * responsibility_get_responsible_for_pid().  Read from macOS 26.5.2 (25F84):
 *
 *  - libquarantine's wrapper (dyld shared cache) reads the 64-bit length
 *    its fourth argument points to when that pointer is non-NULL, fails
 *    with errno ERANGE and -1 when the length is 0, and otherwise hands all
 *    five arguments to its syscall -- so it returns an int, -1 with errno
 *    on failure.
 *  - stock /usr/bin/gcore passes a pid, the address of its pid_t result
 *    and three NULLs.
 *
 * The third argument is never touched by the wrapper, so its type is not
 * recoverable here; it is declared as an untyped pointer.  Only what the
 * tree uses is declared.
 */
#ifndef _RESPONSIBILITY_H_
#define _RESPONSIBILITY_H_

#include <sys/cdefs.h>
#include <sys/types.h>

__BEGIN_DECLS

int responsibility_get_responsible_for_pid(pid_t pid, pid_t *responsible_pid,
    void *responsible_id, size_t *pathlen, char *path);

__END_DECLS

#endif /* _RESPONSIBILITY_H_ */
