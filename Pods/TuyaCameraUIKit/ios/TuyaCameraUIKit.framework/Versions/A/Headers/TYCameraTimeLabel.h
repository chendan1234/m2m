//
//  TYCameraTimeLabel.h
//  TuyaCameraUIKit
//
//  Created by 傅浪 on 2019/11/26.
//

#import <UIKit/UIKit.h>

@interface TYCameraTimeLabel : UIView

/// background color
@property (nonatomic, strong) UIColor *ty_backgroundColor;

/// time string
@property (nonatomic, copy) NSString *timeStr;

/// text font size
@property (nonatomic, assign) NSInteger fontSize;

/// text color
@property (nonatomic, strong) UIColor *textColor;

/// arrow position, 0->left, 1->right, 2->middle
@property (nonatomic, assign) NSInteger position;

@end

