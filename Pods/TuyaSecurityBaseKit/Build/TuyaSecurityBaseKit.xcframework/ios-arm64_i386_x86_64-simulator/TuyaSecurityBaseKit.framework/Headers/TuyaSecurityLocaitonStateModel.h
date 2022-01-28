//
//  TuyaSecurityLocaitonStateModel.h
//  TuyaSecurityBaseKit
//
//  Created by Tuya.Inc on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import "TYSecurityArmAbilityEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityLocaitonStateModel : NSObject

@property (nonatomic, assign) BOOL alarmState;
@property (nonatomic, assign) TYSecurityLocationLineState onlineState;
@property (nonatomic, assign) NSInteger alarmCountdown;


@end

NS_ASSUME_NONNULL_END
