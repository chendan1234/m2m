//
//  AddDeviceNewViewController.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddDeviceNewViewController : UIViewController

@property (nonatomic, assign)NSInteger type; //1.二维码 2.快连

@property (nonatomic, assign)BOOL isWangGuan;

@end

NS_ASSUME_NONNULL_END
