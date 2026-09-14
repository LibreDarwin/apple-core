# libintl -- the gettext bash carries: the intl target of bash.xcodeproj,
# static and only for bash(1).
T_SRCS=	bindtextdom.c dcgettext.c dcigettext.c dcngettext.c dgettext.c \
		dngettext.c explodename.c finddomain.c gettext.c \
		l10nflist.c loadmsgcat.c localcharset.c localealias.c \
		localename.c log.c ngettext.c plural-exp.c plural.c \
		textdomain.c

.include "${TOP}/mk/with-bash.mk"
