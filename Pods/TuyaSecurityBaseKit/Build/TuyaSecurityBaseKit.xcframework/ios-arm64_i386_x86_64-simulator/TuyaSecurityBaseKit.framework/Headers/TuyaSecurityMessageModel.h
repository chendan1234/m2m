//
//  TuyaSecurityMessageModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityMessageModel : NSObject

/// Message create time
@property (nonatomic, copy) NSString *messageContent;

/// Message create time
@property (nonatomic, copy) NSString *messageTitle;

/// Message create time
@property (nonatomic, assign) long long createTime;

/// Message cover
@property (nonatomic, copy) NSString *cover;

/// Message id
@property (nonatomic, copy) NSString *messageId;


@end

NS_ASSUME_NONNULL_END

