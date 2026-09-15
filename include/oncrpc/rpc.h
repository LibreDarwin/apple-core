/*
 * <oncrpc/rpc.h> -- the oncrpc framework's RPC header, as autofs includes it.
 *
 * oncrpc.framework ships no headers in the public SDK, only its stub, and
 * exports its Sun RPC under a _newrpclib_ prefix: stock
 * /usr/libexec/automountd (macOS 26.5.2, 25F84) imports
 * __newrpclib_xdr_string, __newrpclib_clnt_create_timeout and so on.
 * The SDK's own <rpc/*.h> set is byte-for-byte Libinfo-600's rpc.subproj,
 * the same Sun RPC; <oncrpc/newrpclib.h> renames every name oncrpc exports
 * before it is declared.  Stock automountd reaches cl_ops at offset 8 of a
 * CLIENT, as that set lays it out.
 *
 * Below it, oncrpc's additions, read from oncrpc in the dyld shared cache
 * and checked against autofs' calls: clnt_create_timeout() keeps five
 * arguments, clntudp_bufcreate_timeout() and clnttcp_create_timeout()
 * eight, netid2socparms() five and rpc_control() two;
 * RPC_PORTMAP_NETID_SET is the 0x11 stock automountd passes rpc_control()
 * before its TCP portmap call.  rpc_createerr is per-thread, reached
 * through __rpc_createerr().
 */
#ifndef _ONCRPC_RPC_H_
#define _ONCRPC_RPC_H_

#include <oncrpc/newrpclib.h>
#include <rpc/rpc.h>
#include <sys/socket.h>
#include <sys/time.h>

__BEGIN_DECLS

typedef u_int32_t rpcprog_t;
typedef u_int32_t rpcvers_t;
typedef u_int32_t rpcproc_t;

#define RPC_PORTMAP_NETID_SET	0x11

extern struct rpc_createerr *__rpc_createerr(void);
#undef rpc_createerr
#define rpc_createerr	(*(__rpc_createerr()))

extern CLIENT *clnt_create_timeout(char *host, rpcprog_t prog, rpcvers_t vers,
    const char *proto, struct timeval *timeout);
extern CLIENT *clntudp_bufcreate_timeout(struct sockaddr *addr,
    rpcprog_t prog, rpcvers_t vers, int *sockp, u_int sendsz, u_int recvsz,
    struct timeval *retry, struct timeval *timeout);
extern CLIENT *clnttcp_create_timeout(struct sockaddr *addr, rpcprog_t prog,
    rpcvers_t vers, int *sockp, u_int sendsz, u_int recvsz,
    struct timeval *retry, struct timeval *timeout);
extern int netid2socparms(const char *netid, int *family, int *socktype,
    int *protocol, int check);
extern int rpc_control(int request, void *info);

__END_DECLS

#endif /* _ONCRPC_RPC_H_ */
