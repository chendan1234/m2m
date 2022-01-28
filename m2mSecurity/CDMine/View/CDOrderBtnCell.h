//
//  CDOrderBtnCell.h
//  Security
//
//  Created by chendan on 2021/8/4.
//

#import <UIKit/UIKit.h>
#import "CDOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDOrderBtnCell : UITableViewCell

@property (nonatomic, strong)CDOrderModel *model;

@property (nonatomic, copy) void(^myTime)(dispatch_source_t timer);

/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)(CDOrderModel *);

@end

NS_ASSUME_NONNULL_END
