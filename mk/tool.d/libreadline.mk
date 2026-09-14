# libreadline -- readline and history, as bash 3.2 carries them: the readline target of bash.xcodeproj,
# static and only for bash(1).
T_SRCS=	bind.c callback.c compat.c complete.c display.c funmap.c \
		histexpand.c histfile.c history.c histsearch.c input.c \
		isearch.c keymaps.c kill.c macro.c mbutil.c misc.c nls.c \
		parens.c readline.c rltty.c savestring.c search.c \
		signals.c terminal.c text.c tilde.c undo.c util.c \
		vi_keymap.c vi_mode.c xmalloc.c

.include "${TOP}/mk/with-bash.mk"
