# ncurses -- clear, infocmp, tic, toe, tput and tset, from Apple's drop.
#
# The drop is an Xcode project around upstream ncurses 6.0; underneath it
# the tree at ncurses/ is ordinary autoconf, which is what Apple's own
# configure.sh runs, in tree, with these flags.  --with-abi-version=5.4 is
# why the library is libncurses.5.4.
#
# configure ships mode 644 (Apple run it as "sh configure"); the copy gets
# the bit.  generate-syms.py is the second half of configure.sh: it fills
# the @@ABIDECLS@@ marker configure leaves in curses.head, giving every
# declaration its versioned __asm label (putp$NCURSES60, ...).
#
# Only the programs are built.  Stock macOS's link nothing but
# /usr/lib/libncurses.5.4.dylib, which is the OS's, and every symbol they
# take from it -- the _nc_* internals tic and infocmp use included -- is in
# the SDK's libncurses.5.4.tbd.  So include/ is generated, progs/ is built
# against the SDK's library instead of ../lib, and the library itself,
# whose ABI-versioned symbols upstream's Makefiles cannot express, is never
# needed.
P_PREPARE=	chmod +x ncurses/configure
P_CONFIGURE=	ncurses/configure
P_OBJDIR=	${P_WORKDIR}/src/ncurses
P_POST_CONFIGURE=	python3 ../generate-syms.py && make -C include
P_CONFIGURE_ARGS=	--with-shared --without-normal --without-debug \
			--without-cxx-binding --without-cxx --enable-termcap \
			--enable-widec --enable-ext-colors \
			--with-abi-version=5.4 \
			--mandir=/usr/share/man --datarootdir=/usr/share
P_MAKE_ARGS=	-C progs DEPS_CURSES= LIBS_TIC=-lncurses LIBS_TINFO=-lncurses
P_NOSTAGE=	yes
P_PROGS=	progs/clear progs/infocmp progs/tic progs/toe progs/tput \
		progs/tset
# The names stock macOS gives the same programs.
P_RELEASE_SYMLINK=	usr/bin/tset usr/bin/reset \
			usr/bin/tic usr/bin/captoinfo \
			usr/bin/tic usr/bin/infotocap
