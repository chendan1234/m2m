//
//  ShareDeviceLlistViewController.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareDeviceLlistViewController : UIViewController

@property (nonatomic, strong)TuyaSmartShareMemberModel *model;

@property (nonatomic, assign)NSInteger type;//2.我共享给别人 3.别人共享给我

@property (nonatomic, copy) void(^deleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
