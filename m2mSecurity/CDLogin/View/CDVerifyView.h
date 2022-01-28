//
//  CDVerifyView.h
//  security
//
//  Created by chendan on 2021/5/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDVerifyView : UIView

+(instancetype)reload;

@property (nonatomic, assign)NSInteger type;//0验证手机号 1设置新密码
@property (nonatomic, copy) void(^nextBlock)(void);
@property (nonatomic, copy) void(^overBlock)(void);

@end

NS_ASSUME_NONNULL_END
