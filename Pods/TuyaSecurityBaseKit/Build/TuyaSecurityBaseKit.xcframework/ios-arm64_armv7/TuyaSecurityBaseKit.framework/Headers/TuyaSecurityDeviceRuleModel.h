//
//  TuyaSecurityDeviceRuleModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/// the rule 
@interface TuyaSecurityDeviceRuleModel : NSObject

/// gateway device id
@property (nonatomic, copy) NSString *gatewayId;

/// sub device ids
@property (nonatomic, strong) NSArray<NSString *>*deviceIds;

/// type（1: security gateway   2:cloud gateway   3:ipc device）
@property (nonatomic, assign) NSInteger type;


@end

NS_ASSUME_NONNULL_END

