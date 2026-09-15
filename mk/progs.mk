# mk/progs.mk - the tool inventory.
#
# One entry per built program, three whitespace-separated fields:
#
#	PROGS+= <dir-under-src> <program-name> <install-suffix>
#
#   <dir>             submodule directory containing the sources
#   <program-name>    final binary name (.tproj suffixes stripped)
#   <install-suffix>  bin | sbin | usr/bin | usr/sbin | usr/libexec,
#                     mirrored under build/release/.  Suffixes mirror
#                     where stock macOS keeps each tool; entries absent
#                     from stock macOS follow FreeBSD placement.
#
# Internal object libraries (disklib, edt_fstab, mount_flags_dir,
# network_cmds_lib) and non-installed scripts (xscripts) are handled
# elsewhere / skipped.

PROGS+=	adv_cmds/ps ps bin
PROGS+=	adv_cmds/stty stty bin
PROGS+=	file_cmds/chmod chmod bin
PROGS+=	file_cmds/cp cp bin
PROGS+=	file_cmds/dd dd bin
PROGS+=	file_cmds/df df bin
PROGS+=	file_cmds/ln ln bin
PROGS+=	file_cmds/ls ls bin
PROGS+=	file_cmds/mkdir mkdir bin
PROGS+=	file_cmds/mv mv bin
PROGS+=	file_cmds/pax pax bin
PROGS+=	file_cmds/rm rm bin
PROGS+=	file_cmds/rmdir rmdir bin
PROGS+=	shell_cmds/date date bin
PROGS+=	shell_cmds/echo echo bin
PROGS+=	shell_cmds/expr expr bin
PROGS+=	shell_cmds/hostname hostname bin
PROGS+=	shell_cmds/kill kill bin
PROGS+=	shell_cmds/pwd pwd bin
PROGS+=	shell_cmds/realpath realpath bin
PROGS+=	shell_cmds/sh sh bin
PROGS+=	shell_cmds/sleep sleep bin
PROGS+=	shell_cmds/test test bin
PROGS+=	system_cmds/sync sync bin
PROGS+=	system_cmds/wait4path wait4path bin
PROGS+=	text_cmds/cat cat bin
PROGS+=	text_cmds/ed ed bin
PROGS+=	diskdev_cmds/fsck.tproj fsck sbin
PROGS+=	diskdev_cmds/fstyp.tproj fstyp_msdos sbin
PROGS+=	diskdev_cmds/fstyp.tproj fstyp_ntfs sbin
PROGS+=	diskdev_cmds/fstyp.tproj fstyp_udf sbin
PROGS+=	hfs/fstyp_hfs fstyp_hfs sbin
PROGS+=	hfs/fsck_hfs fsck_hfs sbin
PROGS+=	hfs/newfs_hfs newfs_hfs sbin
PROGS+=	hfs/mount_hfs mount_hfs sbin
PROGS+=	diskdev_cmds/mount_devfs.tproj mount_devfs sbin
PROGS+=	diskdev_cmds/mount_fdesc.tproj mount_fdesc sbin
PROGS+=	diskdev_cmds/umount.tproj umount sbin
PROGS+=	file_cmds/mknod mknod sbin
PROGS+=	network_cmds/ifconfig.tproj ifconfig sbin
PROGS+=	network_cmds/ping.tproj ping sbin
PROGS+=	network_cmds/ping6.tproj ping6 sbin
PROGS+=	network_cmds/route.tproj route sbin
PROGS+=	system_cmds/dmesg dmesg sbin
PROGS+=	system_cmds/nologin nologin sbin
PROGS+=	text_cmds/md5 md5 sbin
PROGS+=	adv_cmds/cap_mkdb cap_mkdb usr/bin
PROGS+=	adv_cmds/finger finger usr/bin
PROGS+=	adv_cmds/gencat gencat usr/bin
PROGS+=	adv_cmds/last last usr/bin
PROGS+=	adv_cmds/locale locale usr/bin
PROGS+=	adv_cmds/localedef localedef usr/bin
PROGS+=	adv_cmds/lsvfs lsvfs usr/bin
PROGS+=	adv_cmds/pkill pkill usr/bin
PROGS+=	adv_cmds/tabs tabs usr/bin
PROGS+=	adv_cmds/tty tty usr/bin
PROGS+=	adv_cmds/whois whois usr/bin
PROGS+=	basic_cmds/mesg mesg usr/bin
PROGS+=	basic_cmds/write write usr/bin
PROGS+=	bc/bc bc usr/bin
PROGS+=	bsd_additions/indent indent usr/bin
PROGS+=	diskdev_cmds/fuser.tproj fuser usr/bin
PROGS+=	diskdev_cmds/quota.tproj quota usr/bin
PROGS+=	file_cmds/chflags chflags usr/bin
PROGS+=	file_cmds/cksum cksum usr/bin
PROGS+=	file_cmds/compress compress usr/bin
PROGS+=	file_cmds/du du usr/bin
PROGS+=	file_cmds/gzip gzip usr/bin
PROGS+=	file_cmds/install install usr/bin
PROGS+=	file_cmds/ipcrm ipcrm usr/bin
PROGS+=	file_cmds/ipcs ipcs usr/bin
PROGS+=	file_cmds/mkfifo mkfifo usr/bin
PROGS+=	file_cmds/pathchk pathchk usr/bin
PROGS+=	file_cmds/shar shar usr/bin
PROGS+=	file_cmds/stat stat usr/bin
PROGS+=	file_cmds/touch touch usr/bin
PROGS+=	file_cmds/truncate truncate usr/bin
PROGS+=	file_cmds/xattr xattr usr/bin
PROGS+=	mail_cmds/mail mail usr/bin
PROGS+=	misc_cmds/calendar calendar usr/bin
PROGS+=	misc_cmds/leave leave usr/bin
PROGS+=	misc_cmds/ncal ncal usr/bin
PROGS+=	misc_cmds/tsort tsort usr/bin
PROGS+=	misc_cmds/units units usr/bin
PROGS+=	patch_cmds/cmp cmp usr/bin
PROGS+=	patch_cmds/diff diff usr/bin
PROGS+=	patch_cmds/diff3 diff3 usr/bin
PROGS+=	patch_cmds/diffstat diffstat usr/bin
PROGS+=	patch_cmds/patch patch usr/bin
PROGS+=	patch_cmds/sdiff sdiff usr/bin
PROGS+=	remote_cmds/logger logger usr/bin
PROGS+=	remote_cmds/talk talk usr/bin
PROGS+=	remote_cmds/tftp tftp usr/bin
PROGS+=	remote_cmds/wall wall usr/bin
PROGS+=	shell_cmds/alias alias usr/bin
PROGS+=	shell_cmds/apply apply usr/bin
PROGS+=	shell_cmds/basename basename usr/bin
PROGS+=	shell_cmds/dirname dirname usr/bin
PROGS+=	shell_cmds/env env usr/bin
PROGS+=	shell_cmds/false false usr/bin
PROGS+=	shell_cmds/find find usr/bin
PROGS+=	shell_cmds/getopt getopt usr/bin
PROGS+=	shell_cmds/hexdump hexdump usr/bin
PROGS+=	shell_cmds/id id usr/bin
PROGS+=	shell_cmds/jot jot usr/bin
PROGS+=	shell_cmds/killall killall usr/bin
PROGS+=	shell_cmds/lastcomm lastcomm usr/bin
PROGS+=	shell_cmds/locate locate usr/bin
PROGS+=	shell_cmds/lockf lockf usr/bin
PROGS+=	shell_cmds/logname logname usr/bin
PROGS+=	shell_cmds/mktemp mktemp usr/bin
PROGS+=	shell_cmds/nice nice usr/bin
PROGS+=	shell_cmds/nohup nohup usr/bin
PROGS+=	shell_cmds/printenv printenv usr/bin
PROGS+=	shell_cmds/printf printf usr/bin
PROGS+=	shell_cmds/renice renice usr/bin
PROGS+=	shell_cmds/script script usr/bin
PROGS+=	shell_cmds/seq seq usr/bin
PROGS+=	shell_cmds/shlock shlock usr/bin
PROGS+=	shell_cmds/stdbuf stdbuf usr/bin
PROGS+=	shell_cmds/su su usr/bin
PROGS+=	shell_cmds/tee tee usr/bin
PROGS+=	shell_cmds/time time usr/bin
PROGS+=	shell_cmds/true true usr/bin
PROGS+=	shell_cmds/uname uname usr/bin
PROGS+=	shell_cmds/users users usr/bin
PROGS+=	shell_cmds/w w usr/bin
PROGS+=	shell_cmds/what what usr/bin
PROGS+=	shell_cmds/whereis whereis usr/bin
PROGS+=	shell_cmds/which which usr/bin
PROGS+=	shell_cmds/who who usr/bin
PROGS+=	shell_cmds/xargs xargs usr/bin
PROGS+=	shell_cmds/yes yes usr/bin
PROGS+=	system_cmds/arch arch usr/bin
PROGS+=	system_cmds/at at usr/bin
PROGS+=	system_cmds/chpass chpass usr/bin
PROGS+=	system_cmds/getconf getconf usr/bin
PROGS+=	system_cmds/login login usr/bin
PROGS+=	system_cmds/newgrp newgrp usr/bin
PROGS+=	system_cmds/pagesize pagesize usr/bin
PROGS+=	system_cmds/passwd passwd usr/bin
PROGS+=	text_cmds/banner banner usr/bin
PROGS+=	text_cmds/bintrans bintrans usr/bin
PROGS+=	text_cmds/col col usr/bin
PROGS+=	text_cmds/colrm colrm usr/bin
PROGS+=	text_cmds/column column usr/bin
PROGS+=	text_cmds/comm comm usr/bin
PROGS+=	text_cmds/csplit csplit usr/bin
PROGS+=	text_cmds/cut cut usr/bin
PROGS+=	text_cmds/expand expand usr/bin
PROGS+=	text_cmds/fmt fmt usr/bin
PROGS+=	text_cmds/fold fold usr/bin
PROGS+=	text_cmds/grep grep usr/bin
PROGS+=	text_cmds/head head usr/bin
PROGS+=	text_cmds/join join usr/bin
PROGS+=	text_cmds/jq jq usr/bin
PROGS+=	text_cmds/lam lam usr/bin
PROGS+=	text_cmds/look look usr/bin
PROGS+=	text_cmds/nl nl usr/bin
PROGS+=	text_cmds/paste paste usr/bin
PROGS+=	text_cmds/pr pr usr/bin
PROGS+=	text_cmds/rev rev usr/bin
PROGS+=	text_cmds/rs rs usr/bin
PROGS+=	text_cmds/sed sed usr/bin
PROGS+=	text_cmds/sort sort usr/bin
PROGS+=	text_cmds/split split usr/bin
PROGS+=	text_cmds/tail tail usr/bin
PROGS+=	text_cmds/tr tr usr/bin
PROGS+=	text_cmds/ul ul usr/bin
PROGS+=	text_cmds/unexpand unexpand usr/bin
PROGS+=	text_cmds/uniq uniq usr/bin
PROGS+=	text_cmds/unvis unvis usr/bin
PROGS+=	text_cmds/vis vis usr/bin
PROGS+=	text_cmds/wc wc usr/bin
PROGS+=	foundation_cmds/defaults defaults usr/bin
PROGS+=	foundation_cmds/pl pl usr/bin
PROGS+=	foundation_cmds/plutil plutil usr/bin
PROGS+=	AKCmds/open open usr/bin
PROGS+=	AKCmds/pbcopy pbcopy usr/bin
PROGS+=	AKCmds/textutil textutil usr/bin
PROGS+=	AKCmds/tiff2icns tiff2icns usr/bin
PROGS+=	AKCmds/tiffutil tiffutil usr/bin
PROGS+=	AKCmds/tops tops usr/bin
PROGS+=	BomCmds ditto usr/bin
PROGS+=	BomCmds lsbom usr/bin
PROGS+=	BomCmds mkbom usr/bin
PROGS+=	diskdev_cmds/dirs_cleaner dirs_cleaner usr/libexec
PROGS+=	diskdev_cmds/tmp_cleaner tmp_cleaner usr/libexec
PROGS+=	doc_cmds/makewhatis makewhatis usr/libexec
PROGS+=	shell_cmds/path_helper path_helper usr/libexec
PROGS+=	system_cmds/chkpasswd chkpasswd usr/libexec
PROGS+=	diskdev_cmds/dev_mkdb.tproj dev_mkdb usr/sbin
PROGS+=	diskdev_cmds/edquota.tproj edquota usr/sbin
PROGS+=	diskdev_cmds/fdisk.tproj fdisk usr/sbin
PROGS+=	diskdev_cmds/quotaon.tproj quotaon usr/sbin
PROGS+=	diskdev_cmds/repquota.tproj repquota usr/sbin
PROGS+=	diskdev_cmds/vsdbutil.tproj vsdbutil usr/sbin
PROGS+=	file_cmds/chown chown usr/sbin
PROGS+=	file_cmds/mtree mtree usr/sbin
PROGS+=	network_cmds/arp.tproj arp usr/sbin
PROGS+=	network_cmds/dnctl dnctl usr/sbin
PROGS+=	network_cmds/ndp.tproj ndp usr/sbin
PROGS+=	network_cmds/netstat.tproj netstat usr/sbin
PROGS+=	network_cmds/traceroute.tproj traceroute usr/sbin
PROGS+=	network_cmds/traceroute6.tproj traceroute6 usr/sbin
PROGS+=	shell_cmds/chroot chroot usr/sbin
PROGS+=	system_cmds/ac ac usr/sbin
PROGS+=	system_cmds/accton accton usr/sbin
PROGS+=	system_cmds/mkfile mkfile usr/sbin
PROGS+=	system_cmds/nvram nvram usr/sbin
PROGS+=	system_cmds/pwd_mkdb pwd_mkdb usr/sbin
PROGS+=	system_cmds/sa sa usr/sbin
PROGS+=	system_cmds/sysctl sysctl usr/sbin
PROGS+=	system_cmds/taskpolicy taskpolicy usr/sbin
PROGS+=	system_cmds/vifs vifs usr/sbin
PROGS+=	system_cmds/vipw vipw usr/sbin
PROGS+=	system_cmds/zdump zdump usr/sbin
PROGS+=	system_cmds/zic zic usr/sbin
# genwrap: excluded -- an /AppleInternal-only wrapper generator, not part
# of the stock userland (SUBMODULE_AUDIT.md §2).
#PROGS+=	adv_cmds/genwrap genwrap usr/sbin
PROGS+=	bsd_additions/ee ee usr/bin
PROGS+=	bsd_additions/factor factor usr/bin
PROGS+=	bsd_additions/timeout timeout usr/bin
PROGS+=	diskdev_cmds/setclass.tproj setclass usr/sbin
PROGS+=	network_cmds/rtsol.tproj rtsol usr/sbin
PROGS+=	remote_cmds/telnet telnet usr/bin
PROGS+=	shell_cmds/systime systime usr/bin
PROGS+=	system_cmds/wordexp-helper wordexp-helper usr/libexec

# ------------------------------------------------------------------
# From the submodules added with the move to upstream sources.  Sources
# and flags follow each Apple target (mk/scripts/pbxinfo.py); placements
# are stock macOS's.
# ------------------------------------------------------------------
PROGS+=	awk/src awk usr/bin
PROGS+=	bzip2/bzip2 bzip2 usr/bin
PROGS+=	bzip2/bzip2 bzip2recover usr/bin
PROGS+=	bzip2/bzip2 bzdiff usr/bin
PROGS+=	bzip2/bzip2 bzgrep usr/bin
PROGS+=	bzip2/bzip2 bzmore usr/bin
PROGS+=	disklabel disklabel sbin
PROGS+=	less/less less usr/bin
PROGS+=	less/less lessecho usr/bin
PROGS+=	less/less lesskey usr/bin
PROGS+=	netcat nc usr/bin
PROGS+=	pdisk pdisk usr/sbin
PROGS+=	tidy/tidy/console tidy usr/bin
PROGS+=	top top usr/bin
PROGS+=	bash/bash-3.2 bash bin
PROGS+=	file/file/src file usr/bin
PROGS+=	rsync/openrsync rsync usr/bin
PROGS+=	ipsec/ipsec-tools/setkey setkey usr/sbin
PROGS+=	syslog/newsyslog newsyslog usr/sbin
PROGS+=	syslog/util.tproj syslog usr/bin
PROGS+=	syslog/syslogd.tproj syslogd usr/sbin
PROGS+=	syslog/aslmanager.tproj aslmanager usr/sbin
PROGS+=	screen/screen screen usr/bin
PROGS+=	vim/src vim usr/bin
PROGS+=	vim/src/xxd xxd usr/bin
PROGS+=	PlistBuddy PlistBuddy usr/libexec

# ------------------------------------------------------------------
# MK_DIAGNOSTICS -- system diagnostics and developer tools.  They ship
# with macOS but are not part of the coreutils-like default set, and
# several read kernel interfaces the public SDK does not declare.
# ------------------------------------------------------------------
.if ${MK_DIAGNOSTICS:tl} == "yes"
PROGS+=	system_cmds/dynamic_pager dynamic_pager sbin
PROGS+=	system_cmds/cpuctl cpuctl usr/bin
PROGS+=	system_cmds/fs_usage fs_usage usr/bin
PROGS+=	system_cmds/gcore gcore usr/bin
PROGS+=	system_cmds/hostinfo hostinfo usr/bin
PROGS+=	system_cmds/latency latency usr/bin
PROGS+=	system_cmds/lskq lskq usr/bin
PROGS+=	system_cmds/lsmp lsmp usr/bin
PROGS+=	system_cmds/memory_pressure memory_pressure usr/bin
PROGS+=	system_cmds/sc_usage sc_usage usr/bin
PROGS+=	system_cmds/vm_stat vm_stat usr/bin
PROGS+=	system_cmds/zprint zprint usr/bin
PROGS+=	system_cmds/iostat iostat usr/sbin
PROGS+=	system_cmds/purge purge usr/sbin
PROGS+=	system_cmds/iosim iosim usr/bin
PROGS+=	system_cmds/kpgo kpgo usr/bin
PROGS+=	system_cmds/ltop ltop usr/bin
PROGS+=	system_cmds/mean mean usr/bin
PROGS+=	system_cmds/mslutil mslutil usr/bin
PROGS+=	system_cmds/proc_uuid_policy proc_uuid_policy usr/bin
PROGS+=	system_cmds/stackshot stackshot usr/bin
PROGS+=	system_cmds/vm_purgeable_stat vm_purgeable_stat usr/bin
PROGS+=	system_cmds/zlog zlog usr/bin
.endif

# ------------------------------------------------------------------
# MK_DAEMONS -- network and service daemons, not command-line userland.
# ------------------------------------------------------------------
.if ${MK_DAEMONS:tl} == "yes"
PROGS+=	network_cmds/kdumpd.tproj kdumpd usr/libexec
PROGS+=	remote_cmds/tftpd tftpd usr/libexec
PROGS+=	system_cmds/atrun atrun usr/libexec
PROGS+=	system_cmds/getty getty usr/libexec
PROGS+=	network_cmds/rarpd.tproj rarpd usr/sbin
PROGS+=	network_cmds/rtadvd.tproj rtadvd usr/sbin
PROGS+=	network_cmds/spray.tproj spray usr/sbin
PROGS+=	remote_cmds/talkd talkd usr/sbin
PROGS+=	remote_cmds/telnetd telnetd usr/libexec
.endif

# ------------------------------------------------------------------
# MK_PRIVATE_FRAMEWORKS -- tools that link Apple private frameworks
# absent from the public SDK: FSKit (fsck_fskit, newfs_fskit, fstyp),
# APFS (mount), the quota disk library (quotacheck) and the
# kextmanager MIG interface (reboot, shutdown).
# ------------------------------------------------------------------
.if ${MK_PRIVATE_FRAMEWORKS:tl} == "yes"
PROGS+=	diskdev_cmds/fsck_fskit fsck_fskit sbin
PROGS+=	diskdev_cmds/fstyp.tproj fstyp sbin
PROGS+=	diskdev_cmds/mount.tproj mount sbin
PROGS+=	diskdev_cmds/newfs_fskit newfs_fskit sbin
PROGS+=	diskdev_cmds/quotacheck.tproj quotacheck sbin
PROGS+=	system_cmds/reboot reboot sbin
PROGS+=	system_cmds/shutdown shutdown sbin
.endif
