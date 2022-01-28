//
//  TuyaSecurityBypassDetailModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityBypassDetailModel : NSObject

/// gateway device id
@property (nonatomic, strong) NSString *gwId;

/// gateway state
@property (nonatomic, assign) NSInteger state;

/// gateway subdevice ids
@property (nonatomic, strong) NSArray<NSString *>*bypassDeviceIds;


@end

NS_ASSUME_NONNULL_END

