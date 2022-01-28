//
//  TuyaSecurityModeSettingItemModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityModeSettingItemModel : NSObject

//// allow select
@property (nonatomic, assign) BOOL allowSelect;

/// device id
@property (nonatomic, copy) NSString *deviceId;

/// device name
@property (nonatomic, copy) NSString *name;

/// device icon
@property (nonatomic, copy) NSString *icon;

/// select state
@property (nonatomic, assign) BOOL selectState;

/// mode status
@property (nonatomic, strong) NSArray    *mode;

/// mode new Select status
@property (nonatomic, strong) NSString   *modeNewStatus;

/// isGetway device
@property (nonatomic, assign) BOOL  isMainGateway;

// deviceType 1-securityGateway 2-virtualGateway  3-ipcDevices
@property (nonatomic, assign) NSInteger deviceType;

/// super device
@property (nonatomic, strong) TuyaSecurityModeSettingItemModel *superDevice;

/// gateway sub devices
@property (nonatomic, strong) NSArray<TuyaSecurityModeSettingItemModel *>*subDevices;


@end

NS_ASSUME_NONNULL_END

