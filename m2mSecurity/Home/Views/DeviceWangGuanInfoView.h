//
//  DeviceWangGuanInfoView.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceWangGuanInfoView : UIView

+(instancetype)reload;

@property (nonatomic, strong)TuyaSmartDeviceModel *deviceModel;

@end

NS_ASSUME_NONNULL_END
