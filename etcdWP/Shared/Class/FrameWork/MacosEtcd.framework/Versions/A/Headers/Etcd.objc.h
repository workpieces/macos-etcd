// Objective-C API for talking to yho.io/etcd Go package.
//   gobind -lang=objc yho.io/etcd
//
// File is generated by gobind. Do not edit.

#ifndef __Etcd_H__
#define __Etcd_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


@class EtcdKVClient;

@interface EtcdKVClient : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nullable instancetype)init:(NSString* _Nullable)endpoints username:(NSString* _Nullable)username password:(NSString* _Nullable)password certFile:(NSString* _Nullable)certFile keyFile:(NSString* _Nullable)keyFile CAFile:(NSString* _Nullable)CAFile requestTimeout:(long)requestTimeout dialTimeout:(long)dialTimeout dialKeepAliveTime:(long)dialKeepAliveTime dialKeepAliveTimeout:(long)dialKeepAliveTimeout autoSyncInterval:(long)autoSyncInterval;
- (NSData* _Nullable)authEnable:(BOOL)enable;
- (NSData* _Nullable)changePassword:(NSString* _Nullable)username password:(NSString* _Nullable)password;
- (NSData* _Nullable)children;
- (BOOL)close:(NSError* _Nullable* _Nullable)error;
- (NSData* _Nullable)delete:(NSString* _Nullable)key;
- (NSData* _Nullable)deleteALL;
- (NSData* _Nullable)deletePrefix:(NSString* _Nullable)pre;
- (NSData* _Nullable)deleteRole:(NSString* _Nullable)role;
- (NSData* _Nullable)deleteUser:(NSString* _Nullable)user;
- (NSData* _Nullable)endpointStatus;
- (NSData* _Nullable)get:(NSString* _Nullable)key getConsistency:(NSString* _Nullable)getConsistency;
- (NSData* _Nullable)getALL;
- (NSData* _Nullable)getPrefix:(NSString* _Nullable)pre;
- (NSData* _Nullable)getRev:(NSString* _Nullable)key getRev:(int64_t)getRev;
- (NSData* _Nullable)getSortPrefix:(NSString* _Nullable)prefix getsortOrder:(NSString* _Nullable)getsortOrder getsortTarget:(NSString* _Nullable)getsortTarget;
- (NSData* _Nullable)getUser:(NSString* _Nullable)name;
- (NSData* _Nullable)grant:(long)ttl;
- (NSData* _Nullable)grantUserRole:(NSString* _Nullable)user role:(NSString* _Nullable)role;
- (NSData* _Nullable)keepAliveOnce:(long)leaseid;
- (NSData* _Nullable)leaseList;
- (NSData* _Nullable)leaseRevoke:(NSString* _Nullable)leaseid;
- (NSData* _Nullable)memberAdd:(NSString* _Nullable)endpoint learner:(BOOL)learner;
- (NSData* _Nullable)memberList;
- (NSData* _Nullable)memberRemove:(NSString* _Nullable)id_;
- (NSData* _Nullable)memberUpdate:(NSString* _Nullable)id_ peerUrl:(NSString* _Nullable)peerUrl;
- (BOOL)permission:(NSString* _Nullable)role key:(NSString* _Nullable)key end:(NSString* _Nullable)end error:(NSError* _Nullable* _Nullable)error;
- (BOOL)ping;
- (NSData* _Nullable)promotes:(NSString* _Nullable)id_;
- (NSData* _Nullable)put:(NSString* _Nullable)key value:(NSString* _Nullable)value;
- (NSData* _Nullable)putKeyWithAliveOnce:(NSString* _Nullable)key value:(NSString* _Nullable)value leaseid:(long)leaseid;
- (NSData* _Nullable)putKeyWithLease:(NSString* _Nullable)key value:(NSString* _Nullable)value leaseid:(long)leaseid;
- (NSData* _Nullable)putWithTTL:(NSString* _Nullable)key value:(NSString* _Nullable)value ttl:(long)ttl;
- (NSData* _Nullable)puts:(NSString* _Nullable)key value:(NSString* _Nullable)value leasid:(long)leasid putPrevKV:(BOOL)putPrevKV putIgnoreVal:(BOOL)putIgnoreVal putIgnoreLease:(BOOL)putIgnoreLease;
- (NSData* _Nullable)revokes:(NSString* _Nullable)username rolename:(NSString* _Nullable)rolename;
- (NSData* _Nullable)roleAdd:(NSString* _Nullable)role;
- (NSData* _Nullable)roles;
- (NSData* _Nullable)timeToLive:(BOOL)timeToLiveKeys leaseid:(int64_t)leaseid;
- (NSData* _Nullable)userAdd:(NSString* _Nullable)user password:(NSString* _Nullable)password;
- (NSData* _Nullable)users;
@end

FOUNDATION_EXPORT EtcdKVClient* _Nullable EtcdNewKVClient(NSString* _Nullable endpoints, NSString* _Nullable username, NSString* _Nullable password, NSString* _Nullable certFile, NSString* _Nullable keyFile, NSString* _Nullable CAFile, long requestTimeout, long dialTimeout, long dialKeepAliveTime, long dialKeepAliveTimeout, long autoSyncInterval, NSError* _Nullable* _Nullable error);

FOUNDATION_EXPORT EtcdKVClient* _Nullable EtcdNewMock(void);

#endif
