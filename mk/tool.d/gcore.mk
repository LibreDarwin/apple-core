# gcore(1) -- system_cmds' gcore.
#
# The target compiles these eight files, not everything in gcore/, and
# links libutil (humanize_number, reexec_to_match_lp64ness), as stock gcore
# does.
T_SRCS=		notes.c vanilla.c utils.c corefile.c vm.c main.c sparse.c \
		threads.c
T_LDADD+=	-lutil
#
# <mach-o/dyld_introspection.h> and <mach-o/dyld_process_info.h> are dyld's,
# in include/.  dyld_process_info.h marks API unavailable on bridgeos, a
# platform the public SDK's AvailabilityInternal.h has no macros for; these
# spell it the way that file spells watchos.
# The coalition, persona and process-info names notes.c records
# (COALITION_TYPE_*, PERSONA_ID_NONE, PROC_PIDCOALITIONINFO, ...) sit in
# the PRIVATE sections of xnu's headers in include/ and in
# <sys/proc_info_private.h>, which the internal SDK's <libproc.h> reaches.
T_CFLAGS+=	-DPRIVATE -include sys/proc_info_private.h \
		-I${TOP}/src/libutil -include mach/task_for_pid_private.h \
		'-D__API_AVAILABLE_PLATFORM_bridgeos(x)=bridgeos,introduced=x' \
		'-D__API_DEPRECATED_PLATFORM_bridgeos(x,y)=bridgeos,introduced=x,deprecated=y' \
		'-D__API_UNAVAILABLE_PLATFORM_bridgeos=bridgeos,unavailable'
