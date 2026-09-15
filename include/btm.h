/*
 * <btm.h> -- the BackgroundTaskManagement C SPI system_cmds' atrun uses.
 *
 * Apple publish no copy of this header; the SDK's
 * BackgroundTaskManagement.tbd exports btm_get_enablement_status_for_subsystem_and_uid
 * and the data symbol btm_subsystem_cron.  Read from macOS 26.5.2 (25F84):
 *
 *  - btm_subsystem_cron, in BackgroundTaskManagement (dyld shared cache),
 *    is a pointer to the C string "BTMSubsystemCron" (its neighbour
 *    btm_subsystem_quicklook points to "BTMSubsystemQuickLook"); stock
 *    /usr/libexec/atrun loads its value as the first argument.
 *  - atrun passes BTMGlobalDataUID as a 32-bit -2 and the address of a
 *    one-byte bool, treats a non-zero result as btm_error_none failing, and
 *    compares the bool with 1.
 *
 * Only what the tree uses is declared.
 */
#ifndef _BTM_H_
#define _BTM_H_

#include <sys/cdefs.h>
#include <sys/types.h>
#include <stdbool.h>

__BEGIN_DECLS

typedef const char *btm_subsystem_t;

typedef enum {
	btm_error_none	= 0,
} btm_error_code_t;

#define BTMGlobalDataUID	((uid_t)-2)

extern const btm_subsystem_t btm_subsystem_cron;

extern btm_error_code_t btm_get_enablement_status_for_subsystem_and_uid(
    btm_subsystem_t subsystem, uid_t uid, bool *enabled);

__END_DECLS

#endif /* _BTM_H_ */
