//
//  ArmInfoViewController.h
//  m2mSecurity
//
//  Created by chendan on 2022/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArmInfoViewController : UIViewController

@property (nonatomic, copy) void(^overBlcok)(void);

@property (nonatomic, strong)NSArray *dataArr;

@property (nonatomic, strong)NSString *des;

@end

NS_ASSUME_NONNULL_END
