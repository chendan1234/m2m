//
//  CDPayView.h
//  Security
//
//  Created by chendan on 2021/8/2.
//

#import <UIKit/UIKit.h>
#import "CDSubscribeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPayView : UIView

+(instancetype)reload;

@property (nonatomic, strong)CDSubscribeModel *model;

@property (nonatomic, copy) void(^payBlock)(CDSubscribeModel *model);

@end

NS_ASSUME_NONNULL_END
