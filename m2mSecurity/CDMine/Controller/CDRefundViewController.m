//
//  CDRefundViewController.m
//  Security
//
//  Created by chendan on 2021/8/5.
//

#import "CDRefundViewController.h"
#import "CDHelper.h"
#import "HttpRequest.h"
#import "UIView+ProgressView.h"

@interface CDRefundViewController ()
@property (weak, nonatomic) IBOutlet UITextField *reasonTF;

@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end

@implementation CDRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"申请退款";
    
    [self setUI];
}

-(void)setUI{
    if (self.orderModel) {
        self.orderNumLab.text = [NSString stringWithFormat:@"订单号: %@",self.orderModel.orderNumber];
        self.serviceNameLab.text = self.orderModel.serviceName;
        self.moneyLab.text = [NSString stringWithFormat:@"实付: %ld",self.orderModel.money];
        self.timeLab.text = [CDHelper time_timestampToString:self.orderModel.createTime/1000];
    }else{
        self.orderNumLab.text = [NSString stringWithFormat:@"订单号: %@",self.detailModel.orderNumber];
        self.serviceNameLab.text = self.detailModel.serviceName;
        self.moneyLab.text = [NSString stringWithFormat:@"实付: %ld",self.detailModel.money];
        self.timeLab.text = [CDHelper time_timestampToString:self.detailModel.createTime];
    }
}


- (IBAction)refund:(id)sender {
    if (self.reasonTF.text.length == 0) {
        [self.view pv_warming:@"请输入退款理由!"];
        return;
    }
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"reasonForRefund"] = self.reasonTF.text;
    if (self.orderModel) {
        parames[@"appOrderId"] = self.orderModel.orderId;
    }else{
        parames[@"appOrderId"] = self.detailModel.orderId;
    }
    
    [self.view pv_showTextDialog:@"正在申请退款..."];
    [HttpRequest HR_RefundWithParams:parames success:^(id result) {
        NSLog(@"申请退款 --- %@",result);
        if ([result[@"code"] intValue] == 200) {
            [self.view pv_successLoading:@"退款申请成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        NSLog(@"申请退款error --- %@",error);
        [self.view pv_failureLoading:KNetWorkError];
    }];
    
}




@end
