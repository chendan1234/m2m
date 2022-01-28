//
//  TYMenuListDefaultCell.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/12/5.
//

#import <UIKit/UIKit.h>

#import "TYMenuListViewController.h"

@interface TYMenuListDefaultCellData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;

/// 设置图片颜色
@property (nonatomic, strong) UIColor *tintColor;


+ (instancetype)dataWithTitle:(NSString *)title image:(UIImage *)image;
+ (instancetype)dataWithTitle:(NSString *)title image:(UIImage *)image tintColor:(UIColor *)tintColor;

@end

@interface TYMenuListDefaultCell : UITableViewCell <TYMenuListCellProtocol>

@end
