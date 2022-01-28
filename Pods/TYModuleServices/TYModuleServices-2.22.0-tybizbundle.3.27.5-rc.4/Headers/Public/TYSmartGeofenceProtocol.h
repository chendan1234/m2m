//
//  TYSmartGeofenceProtocol.h
//  TYModuleServices
//
//  Created by TuyaInc. on 2020/9/26.
//

#import <Foundation/Foundation.h>

@class TYGeofenceDataEntity;

static NSString *const kHasShowGeofencePrivacyToast = @"kHasShowGeofencePrivacyToast";

typedef void(^GeoFenceSuccessHandle)(TYGeofenceDataEntity  * _Nonnull fenceData);

typedef void(^OpenGeofenceMapSuccessBlock)(TYGeofenceDataEntity  * _Nonnull fenceData);

typedef void(^OpenGeofenceMapFailBlock)(NSDictionary * _Nonnull dic);

NS_ASSUME_NONNULL_BEGIN

@protocol TYSmartGeofenceProtocol <NSObject>

- (void)selectGeoFenceWithFenceData:(TYGeofenceDataEntity * _Nullable)fenceData success:(GeoFenceSuccessHandle)success;

/**
打开地理围栏地图页面，获取地理围栏信息（新建或编辑地理围栏）
 */
- (void)openGeofenceMap:(TYGeofenceDataEntity * _Nullable)fenceData success:(OpenGeofenceMapSuccessBlock)success failure:(OpenGeofenceMapFailBlock)failure;
    
@end

NS_ASSUME_NONNULL_END
