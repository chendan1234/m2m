//
//  HomeDeleteViewController.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeDeleteViewController : UIViewController

@property (nonatomic, strong)TuyaSmartHomeModel *model;

@property (nonatomic, copy) void(^deleteBlock)(TuyaSmartHomeModel *model);

@end

NS_ASSUME_NONNULL_END
