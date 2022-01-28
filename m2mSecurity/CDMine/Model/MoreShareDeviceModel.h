//
//  MoreShareDeviceModel.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreShareDeviceModel : NSObject

@property (nonatomic, strong) TuyaSmartDeviceModel *model;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
