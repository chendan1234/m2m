//
//  CDMailRegisterView.h
//  security
//
//  Created by chendan on 2021/5/25.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN



@interface CDMailRegisterView : UIView

+(instancetype)reload;

-(void)goToRegister;

@property (nonatomic, assign) NSInteger type;//0手机号 1邮箱

@property (nonatomic, strong) BOOL(^myBlock)();



@end

NS_ASSUME_NONNULL_END
