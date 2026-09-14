# vim(1) -- the vim target of vim.xcodeproj, with Apple's pre-configured
# src/auto/config.h.  Every source is compiled with -include
# vim_dynamic_config.h, which Apple's script phase writes from the version
# of the SDK's Ruby.framework, and generated the same way here.
T_SRCS=	vim9compile.c blob.c src/vim/src/auto/pathdef.c vim9expr.c \
		buffer.c charset.c diff.c digraph.c highlight.c \
		vim9type.c testing.c edit.c autocmd.c eval.c ex_cmds.c \
		ex_cmds2.c ex_docmd.c ex_eval.c ex_getln.c clipboard.c \
		logfile.c os_macosx.m textformat.c drawscreen.c \
		vim9script.c fileio.c arabic.c fold.c evalvars.c \
		spellsuggest.c getchar.c cmdexpand.c dict.c hardcopy.c \
		textobject.c change.c hashtab.c float.c if_cscope.c \
		help.c typval.c register.c crypt.c linematch.c \
		vim9class.c cmdhist.c if_xcmdsrv.c main.c tabpanel.c \
		mark.c mbyte.c optionstr.c popupmenu.c tuple.c json.c \
		match.c userfunc.c memfile.c memline.c cindent.c \
		findfile.c menu.c mouse.c message.c alloc.c misc1.c \
		misc2.c move.c os_mac_conv.c gui_xim.c netbeans.c \
		insexpand.c popupwin.c normal.c usercmd.c vim9instr.c \
		pty.c ops.c option.c quickfix.c map.c evalwindow.c \
		locale.c regexp.c channel.c crypt_zip.c textprop.c \
		screen.c spellfile.c session.c strings.c search.c sign.c \
		spell.c bufwrite.c syntax.c job.c tag.c filepath.c \
		indent.c list.c term.c drawline.c arglist.c debugger.c \
		time.c evalfunc.c gc.c fuzzy.c clientserver.c \
		evalbuffer.c profiler.c viminfo.c ui.c vim9cmds.c undo.c \
		vim9generics.c version.c window.c terminal.c os_unix.c \
		blowfish.c sha256.c scriptfile.c vim9execute.c
VIM_GEN=	${TOP}/build/gen/vim
T_CFLAGS+=	-std=gnu11 -D_FORTIFY_SOURCE=0 -DHAVE_CONFIG_H -DMACOS_X_DARWIN \
		-I${TOP}/src/vim/src -I${TOP}/src/vim/src/proto \
		-I${TOP}/src/vim/src/libvterm/include \
		-include ${VIM_GEN}/vim_dynamic_config.h
# The frameworks Xcode links implicitly: os_macosx.m's clipboard is AppKit,
# os_mac_conv.c's conversions CoreServices, both over CoreFoundation.
T_LDADD+=	${LIBDIR}/libvterm.a -lncurses -liconv \
		-framework CoreFoundation -framework CoreServices -framework AppKit

${VIM_GEN}/vim_dynamic_config.h:
	@mkdir -p ${.TARGET:H}
	v=$$(readlink $$(xcrun --show-sdk-path)/System/Library/Frameworks/Ruby.framework/Versions/Current | sed 's:\.::'); \
	{ echo "#define DYNAMIC_RUBY_VER $$v"; echo "#define RUBY_VERSION $$v"; } > ${.TARGET}

.for s in ${T_SRCS}
${T_OBJDIR}/${s:T:R}.o: ${VIM_GEN}/vim_dynamic_config.h
.endfor
