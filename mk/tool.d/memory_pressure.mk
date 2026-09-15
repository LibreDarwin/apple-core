# memory_pressure(1) -- system_cmds' memory_pressure.
#
# memory_pressure.c includes <dispatch/private.h>, which include/dispatch
# carries from libdispatch-1542.0.4.  Those private headers mark API
# unavailable on bridgeos, a platform the public SDK's AvailabilityInternal.h
# has no macros for; these spell it the way that file spells watchos.
T_CFLAGS+=	'-D__API_AVAILABLE_PLATFORM_bridgeos(x)=bridgeos,introduced=x' \
		'-D__API_DEPRECATED_PLATFORM_bridgeos(x,y)=bridgeos,introduced=x,deprecated=y' \
		'-D__API_UNAVAILABLE_PLATFORM_bridgeos=bridgeos,unavailable'
