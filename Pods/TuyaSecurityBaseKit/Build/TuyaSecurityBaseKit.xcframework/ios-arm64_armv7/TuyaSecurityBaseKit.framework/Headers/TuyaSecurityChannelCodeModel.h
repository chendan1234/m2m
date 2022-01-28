//
//  TuyaSecurityChannelCodeModel.h
//  TuyaSecurityBaseKit
//
//  //  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/) 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityChannelCodeModel : NSObject

/// Whether the service code is bind
@property (nonatomic, assign) BOOL isBind;

/// The service code when the service code is bound
@property (nonatomic, copy) NSString *code;

/// The dealerId
@property (nonatomic, copy) NSString *dealerId;

/// The channelId
@property (nonatomic, copy) NSString *channelId;
@end

NS_ASSUME_NONNULL_END
