/*
 * <mach/task_for_pid_private.h> -- apple-core's declarations of the read
 * and inspect variants of task_for_pid(), for system_cmds' lsmp and
 * vm_purgeable_stat.
 *
 * Apple publish no header declaring them; libsystem_kernel's SDK stub
 * exports both.  Stock /usr/bin/lsmp (macOS 26.5.2, 25F84) calls
 * task_read_for_pid() with a 32-bit port name, a pid and the address of a
 * port name, as the public task_for_pid() in <mach/mach_traps.h> takes, and
 * xnu-12377.121.6's own tests call it the same way
 * (task_read_for_pid(mach_task_self(), getpid(), &port)).
 */
#ifndef _MACH_TASK_FOR_PID_PRIVATE_H_
#define _MACH_TASK_FOR_PID_PRIVATE_H_

#include <sys/cdefs.h>
#include <mach/port.h>
#include <mach/kern_return.h>

__BEGIN_DECLS

extern kern_return_t task_read_for_pid(mach_port_name_t target_tport,
    int pid, mach_port_name_t *t);
extern kern_return_t task_inspect_for_pid(mach_port_name_t target_tport,
    int pid, mach_port_name_t *t);

__END_DECLS

#endif /* _MACH_TASK_FOR_PID_PRIVATE_H_ */
