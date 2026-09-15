# ncurses -- clear, infocmp, tic, toe, tput and tset, from Apple's drop.
#
# The drop is an Xcode project around upstream ncurses 6.0; underneath it
# the tree at ncurses/ is ordinary autoconf, which is what Apple's own
# configure.sh runs, in tree, with these flags.  --with-abi-version=5.4 is
# why the libraries are libncurses.5.4 and the programs link that name --
# which, run from the release tree, is the system's copy.
#
# configure ships mode 644 (Apple run it as "sh configure"); the copy gets
# the bit.  generate-syms.py is the second half of configure.sh: it fills
# the @@ABIDECLS@@ marker configure leaves in curses.head.
#
# NOT BUILT YET: Apple version every export by ABI.  generate-syms.py gives
# each declaration in curses.h an __asm label, so the library objects
# define addch$NCURSES60 and friends, while base/nc_abi.c -- Apple's
# compatibility layer, which also defines _nc_abiver -- expects the plain
# names beside them.  Apple's Xcode project builds nc_abi.c apart from the
# rest; upstream's modules list and generated Makefiles have no way to say
# so, and adding nc_abi to them links with every plain name undefined.
# Doing this properly means compiling the library from Apple's target
# rather than through configure's Makefiles.
P_NOBUILD=	yes

P_PREPARE=	chmod +x ncurses/configure
P_CONFIGURE=	ncurses/configure
P_OBJDIR=	${P_WORKDIR}/src/ncurses
P_POST_CONFIGURE=	python3 ../generate-syms.py
P_CONFIGURE_ARGS=	--with-shared --without-normal --without-debug \
			--without-cxx-binding --without-cxx --enable-termcap \
			--enable-widec --enable-ext-colors \
			--with-abi-version=5.4 \
			--mandir=/usr/share/man --datarootdir=/usr/share
P_NOSTAGE=	yes
P_PROGS=	progs/clear progs/infocmp progs/tic progs/toe progs/tput \
		progs/tset
# The names stock macOS gives the same programs.
P_RELEASE_SYMLINK=	usr/bin/tset usr/bin/reset \
			usr/bin/tic usr/bin/captoinfo \
			usr/bin/tic usr/bin/infotocap
