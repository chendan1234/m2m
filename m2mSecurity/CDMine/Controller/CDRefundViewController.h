//
//  CDRefundViewController.h
//  Security
//
//  Created by chendan on 2021/8/5.
//

#import <UIKit/UIKit.h>
#import "CDOrderModel.h"
#import "CDOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDRefundViewController : UIViewController

@property (nonatomic,strong)CDOrderModel *orderModel;

@property (nonatomic,strong)CDOrderDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
