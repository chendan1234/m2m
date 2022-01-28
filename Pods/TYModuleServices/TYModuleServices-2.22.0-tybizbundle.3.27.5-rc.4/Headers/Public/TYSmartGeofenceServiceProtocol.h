//
//  TYSmartGeofenceServiceProtocol.h
//  AFNetworking
//
//  Created by YouLi on 2020/11/22.
//

#import <Foundation/Foundation.h>

@class TYGeofenceDataEntity;

NS_ASSUME_NONNULL_BEGIN

typedef void(^RegisterGeofenceSuccessBlock)(NSString * _Nonnull str);

typedef void(^UnregisterGeofenceFailBlock)(NSDictionary * _Nonnull dic);

@protocol TYSmartGeofenceServiceProtocol <NSObject>

//是否到达地理围栏限制的20个数量的限额
- (BOOL)isGeofenceReachLimit;

- (void)registerGeofenceWithFenceData:(TYGeofenceDataEntity * _Nullable)fenceData success:(RegisterGeofenceSuccessBlock)success failure:(UnregisterGeofenceFailBlock)failure;

- (void)unregisterGeofenceWithFenceData:(TYGeofenceDataEntity * _Nullable)fenceData success:(RegisterGeofenceSuccessBlock)success failure:(UnregisterGeofenceFailBlock)failure;

- (void)updateGeofenceWithRegisterAry:(NSArray<TYGeofenceDataEntity *> *)registerAry unregisterAry:(NSArray<TYGeofenceDataEntity *> *)unregisterAry success:(RegisterGeofenceSuccessBlock)success failure:(UnregisterGeofenceFailBlock)failure;

- (void)getAllSmartGeofenceListAndRegisterGeofenceIntoSystem;

- (void)removeAllMonitors;

@end

NS_ASSUME_NONNULL_END
