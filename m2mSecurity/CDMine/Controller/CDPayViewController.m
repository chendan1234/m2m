//
//  CDPayViewController.m
//  Security
//
//  Created by chendan on 2021/8/2.
//

#import "CDPayViewController.h"
#import "CDPayView.h"
#import "CDCommonDefine.h"
#import "UIView+ProgressView.h"
#import "CDHelper.h"
@import Stripe;

@interface CDPayViewController ()<UITableViewDelegate,UITableViewDataSource,STPAuthenticationContext>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation CDPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"付款";
    
    [self setUI];
}

-(void)setUI{
    CDPayView *payView = [CDPayView reload];
    payView.frame = CGRectMake(0, 0, DEVICE_WIDRH, 500);
    payView.model = self.model;
    
    
    [payView setPayBlock:^(CDSubscribeModel * _Nonnull model) {
        self.model = model;
        [CDHelper setupAlterWithVC:self title:@"确认支付?" message:@"" sure:^{
            [self pay];
        }];
    }];
    
    UIView *bgV = [[UIView alloc]initWithFrame:payView.bounds];
    [bgV addSubview:payView];
    
    self.myTableView.tableHeaderView = bgV;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}




-(void)pay{
    [self.view pv_showTextDialog:@"正在付款, 请稍后..."];
    
    STPPaymentMethodCardParams *cardParams = [[STPPaymentMethodCardParams alloc]init];
    cardParams.number = self.model.num;
    cardParams.expYear = @(self.model.expYear);
    cardParams.expMonth = @(self.model.expMonth);
    cardParams.cvc = self.model.cvc;
    
    
    
    STPPaymentMethodParams *paymentMethodParams = [STPPaymentMethodParams paramsWithCard:cardParams billingDetails:nil metadata:nil];
    STPPaymentIntentParams *paymentIntentParams = [[STPPaymentIntentParams alloc] initWithClientSecret:self.model.paymentIntentClientSecret];
    paymentIntentParams.paymentMethodParams = paymentMethodParams;

    // Submit the payment
    STPPaymentHandler *paymentHandler = [STPPaymentHandler sharedHandler];
    [paymentHandler confirmPayment:paymentIntentParams withAuthenticationContext:self completion:^(STPPaymentHandlerActionStatus status, STPPaymentIntent *paymentIntent, NSError *error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        switch (status) {
          case STPPaymentHandlerActionStatusFailed: {
              [self.view pv_failureLoading:@"支付失败!"];
            break;
          }
          case STPPaymentHandlerActionStatusCanceled: {
              [self.view pv_warming:@"取消支付"];
            break;
          }
          case STPPaymentHandlerActionStatusSucceeded: {
              [self.view pv_successLoading:@"支付成功!"];
              [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateExpireTime object:nil];//支付成功, 更新到期时间
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [self.navigationController popToRootViewControllerAnimated:YES];
              });
            break;
          }
          default:
            break;
        }
      });
    }];
}


# pragma mark STPAuthenticationContext
- (UIViewController *)authenticationPresentingViewController {
  return self;
}

@end
