//
//  CDChangePhoneOrEmailView.h
//  security
//
//  Created by chendan on 2021/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDChangePhoneOrEmailView : UIView

+(instancetype)reload;

@property (nonatomic, assign)NSInteger type;//0验证 1设置
@property (nonatomic, assign)NSInteger from;//0手机号 1邮箱 2邮箱设手机 3手机设邮箱
@property (nonatomic, copy) void(^nextBlock)(void);
@property (nonatomic, copy) void(^overBlock)(void);

@end

NS_ASSUME_NONNULL_END
