//
//  DeviceDetailCell.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/18.
//

#import <UIKit/UIKit.h>
#import "DeviceLogListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceDetailCell : UITableViewCell

@property (nonatomic, strong)DeviceLogListModel *model;

@property (nonatomic, strong)TuyaSmartDeviceModel *deviceModel;

@end

NS_ASSUME_NONNULL_END
