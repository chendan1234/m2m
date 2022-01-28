//
//  MenLingViewController.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenLingViewController : UIViewController

@property (nonatomic, strong)TuyaSmartDeviceModel *deviceModel;

- (instancetype)initWithDeviceId:(NSString *)devId;

@end

NS_ASSUME_NONNULL_END
