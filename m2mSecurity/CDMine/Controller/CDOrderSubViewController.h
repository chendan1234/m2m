//
//  CDOrderSubViewController.h
//  Security
//
//  Created by chendan on 2021/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDOrderSubViewController : UIViewController

@property (nonatomic, assign)NSInteger type;//0:全部 1：待付款 2：服务中 5：已过期 8: 其他

@end

NS_ASSUME_NONNULL_END
