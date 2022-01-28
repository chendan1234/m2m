//
//  DeviceInfoViewController.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//定义设备类型
typedef enum{
    DeviceInfoFormDefault  = 0,
    DeviceInfoFormShengGuang,
    DeviceInfoFormWangGuan,
    DeviceInfoFormShiPing,
} DeviceInfoForm;

@interface DeviceInfoViewController : UIViewController

@property (nonatomic, assign)BOOL isChild;//是否是子设备进入

@property (nonatomic, strong)TuyaSmartDeviceModel *deviceModel;

@property (nonatomic, assign) DeviceInfoForm form;

@end

NS_ASSUME_NONNULL_END
