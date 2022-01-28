//
//  UIFont+TYCommonFont.h
//  TYUIKit
//
//  Created by 尼诺 on 2021/5/12.
//

#import <UIKit/UIKit.h>
#import "UIFont+TYAlphanumeric.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (TYCommonFont)

+ (BOOL)ty_registerFont:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
