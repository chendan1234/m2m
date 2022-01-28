//
//  TuyaSecurityAlarmOperationModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/// alarm action
@interface TuyaSecurityAlarmOperationModel : NSObject

/// Action description
@property (nonatomic, copy) NSString *operationDescription;

/// Action type
@property (nonatomic, assign) NSInteger type;


@end

NS_ASSUME_NONNULL_END

