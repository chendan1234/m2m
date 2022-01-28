//
//  HomeManageViewController.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeManageViewController : UIViewController

@property (nonatomic, copy)void(^deleteSelectBlock)(void);

@end

NS_ASSUME_NONNULL_END
