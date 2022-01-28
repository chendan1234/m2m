//
//  CDOrderLabCell.m
//  Security
//
//  Created by chendan on 2021/8/4.
//

#import "CDOrderLabCell.h"
#import "CDHelper.h"

@interface CDOrderLabCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end

@implementation CDOrderLabCell

-(void)setModel:(CDOrderModel *)model{
    _model = model;
    
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号: %@",model.orderNumber];
    
    self.serviceNameLab.text = model.serviceName;
    
    self.createTimeLab.text = [CDHelper time_timestampToString:model.createTime/1000];
    self.timeLab.text = [CDHelper getServiceDayWith:model.life];
    self.moneyLab.text = [NSString stringWithFormat:@"实付 ¥%ld",model.money];
    
    switch (model.status) {
        case 7://拒绝退款
        {
            self.statusLab.text = @"拒绝退款";
            self.statusLab.textColor = [CDHelper getColor:@"D0021B"];
        }
            break;
        case 6://已关闭
        {
            self.statusLab.text = @"已关闭";
            self.statusLab.textColor = [CDHelper getColor:@"888888"];
        }
            break;
        case 5://已过期
        {
            self.statusLab.text = @"已过期";
            self.statusLab.textColor = [CDHelper getColor:@"888888"];
        }
            break;
        case 4://退款中
        {
            self.statusLab.text = @"退款中";
            self.statusLab.textColor = [CDHelper getColor:@"D0021B"];
        }
            break;
        case 3://待审核
        {
            self.statusLab.text = @"待审核";
            self.statusLab.textColor = [CDHelper getColor:@"D0021B"];
        }
            break;
            
        default:
            break;
    }
}

@end
