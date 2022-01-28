//
//  SelectHomeView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectHomeView : UIView

@property (nonatomic, copy) void(^myBlock)(void);//0点击cell 1点击家庭管理

+(instancetype)reload;

@end

NS_ASSUME_NONNULL_END
