//
//  TuyaSecurityChannelConfigResultModel.h
//  TuyaSecurityBaseKit
//
//  //  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/) 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityChannelConfigResultModel : NSObject

///  Channel Management Switch
@property (nonatomic, assign) BOOL enableChannelBind;

///  Temporarily Management Switch
@property (nonatomic, assign) BOOL enableSkipBind;

/// Temporarily Management Switch
@property (nonatomic, assign) BOOL enableBindDealer;



@end

NS_ASSUME_NONNULL_END
