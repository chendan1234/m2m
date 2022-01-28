//
//  TuyaSecurityHomeBaseStateModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityHomeStateType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityHomeBaseStateModel : NSObject

@property (nonatomic, assign) TuyaSecurityHomeStateType type;

@property (nonatomic, copy) NSString *stateDescription;


@end

NS_ASSUME_NONNULL_END

