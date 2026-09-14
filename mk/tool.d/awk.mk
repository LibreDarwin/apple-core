# awk(1) -- the one true awk, as awk.xcodeproj builds it.  awkgram.tab.c
# ships pre-generated, so the grammar is not run through yacc again, and
# maketab.c -- the generator proctab.c came from -- is not linked.
T_SRCS=		b.c lex.c lib.c awkgram.tab.c main.c parse.c proctab.c \
		run.c tran.c
