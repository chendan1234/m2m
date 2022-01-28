//
//  UIFont+TYAlphanumeric.h
//  TYUIKit
//
//  Created by 尼诺 on 2021/5/11.
//

#import <UIKit/UIKit.h>
#import "UIFont+TYCommonFont.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (TYAlphanumeric)

+ (UIFont *)ty_alphanumericRegular:(CGFloat)size;
+ (UIFont *)ty_alphanumericMedium:(CGFloat)size;
+ (UIFont *)ty_alphanumericBold:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
