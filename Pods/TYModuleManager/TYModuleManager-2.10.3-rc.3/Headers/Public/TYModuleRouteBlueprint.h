//
//  TYModuleRouteBlueprint.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/8/21.
//

#import <Foundation/Foundation.h>

#import "TYModuleBaseBlueprint.h"

NS_ASSUME_NONNULL_BEGIN

@class TYModuleRouteInfo;

@protocol TYModuleRouteBlueprint <TYModuleBaseBlueprint>

/**
 scheme、path、query will be ignore
 */
- (void)registRoute:(NSString *)route forModule:(id)module;
- (void)unregistRoute:(NSString *)route;

- (nullable id)moduleOfRoute:(NSString *)route;


- (BOOL)canOpenRoute:(NSString *)route;

/**
 scheme、path、query will passthrough to the handle impl
 */
- (BOOL)openRoute:(NSString *)route withParams:(nullable NSDictionary *)params;
/**
scheme、path、query 、callBack will passthrough to the handle impl
attention：because of connecting to Flutter，result in callBack must be serializable（可序列化）
*/
- (BOOL)openRoute:(NSString *)route withParams:(nullable NSDictionary *)params callBack:(void(^)(NSDictionary *result))callBack;

- (void)registerUnhandledRoute:(BOOL(^)(NSString *scheme, NSString *host, NSString *path, NSDictionary *params))callback;

@end

NS_ASSUME_NONNULL_END
