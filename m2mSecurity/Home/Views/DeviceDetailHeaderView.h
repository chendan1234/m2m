//
//  DeviceDetailHeaderView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceDetailHeaderView : UIView

+(instancetype)reload;

@property (nonatomic, strong)TuyaSmartDeviceModel *model;

@end

NS_ASSUME_NONNULL_END
