//
//  CDOrderBtnCell.m
//  Security
//
//  Created by chendan on 2021/8/4.
//

#import "CDOrderBtnCell.h"
#import "CDHelper.h"
#import "CDRefundViewController.h"
#import "CDSubscribeModel.h"
#import "CDPayViewController.h"

#import "OYCountDownManager.h"

@interface CDOrderBtnCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UILabel *daoTimeLab;

@end

@implementation CDOrderBtnCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
    }
    return self;
}


#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }
    /// 计算倒计时
    NSInteger timeout = self.model.createTime/1000 + 15*60 - [[NSDate date] timeIntervalSince1970];
    /// 当倒计时到了进行回调
    if (timeout <= 0) {
        self.daoTimeLab.text = @"剩余00:00";
        // 回调给控制器
        if (self.countDownZero) {
            self.countDownZero(self.model);
        }
        return;
    }
    /// 重新赋值
    self.daoTimeLab.text = [NSString stringWithFormat:@"剩余%02zd:%02zd",timeout/60, timeout%60];
}



-(void)setModel:(CDOrderModel *)model{
    _model = model;
    
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号: %@",model.orderNumber];
    
    self.serviceNameLab.text = model.serviceName;

    self.createTimeLab.text = [CDHelper time_timestampToString:model.createTime/1000];
    self.timeLab.text = [CDHelper getServiceDayWith:model.life];
    self.moneyLab.text = [NSString stringWithFormat:@"实付 ¥%ld",model.money];
    
    if (model.status == 1) {
        self.statusLab.text = @"待付款";
        self.daoTimeLab.hidden = NO;
//        [CDHelper countTimeWithLab:self.daoTimeLab time:model.createTime];
        [self countDownNotification];
        self.statusLab.textColor = [CDHelper getColor:@"E73F3F"];
        [self.actionBtn setTitle:@"付款" forState:UIControlStateNormal];
    }else{
        self.statusLab.text = @"服务中";
        self.daoTimeLab.hidden = YES;
//        [CDHelper countTimeWithLab:self.daoTimeLab time:model.createTime];
        self.statusLab.textColor = [CDHelper getColor:@"7ED321"];
        [self.actionBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    }
}

//申请退款或去付款
- (IBAction)btnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqual:@"申请退款"]) {//
        CDRefundViewController *refundVC = [[CDRefundViewController alloc]init];
        refundVC.orderModel = self.model;
        [[CDHelper viewControllerWithView:self].navigationController pushViewController:refundVC animated:YES];
    }else{//付款
        CDSubscribeModel *model = [[CDSubscribeModel alloc]init];
        model.serviceName = self.model.serviceName;
        model.serviceDay = self.model.life;
        model.money = self.model.money * 100;
        
        NSDictionary *dic = [CDHelper jsonToDic:self.model.payment];
        model.paymentIntentClientSecret = dic[@"clientSecret"];
        
        CDPayViewController *payVC = [[CDPayViewController alloc]init];
        payVC.model = model;
        [[CDHelper viewControllerWithView:self].navigationController pushViewController:payVC animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
