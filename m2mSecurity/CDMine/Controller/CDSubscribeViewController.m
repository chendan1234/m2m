//
//  CDSubscribeViewController.m
//  Security
//
//  Created by chendan on 2021/7/29.
//

#import "CDSubscribeViewController.h"
#import "CDCommonDefine.h"
#import "CDHelper.h"
#import "HttpRequest.h"
#import "UIView+ProgressView.h"
#import "CDSubscribeModel.h"
#import "CDPayViewController.h"

@import Stripe;

@interface CDSubscribeViewController ()<STPAuthenticationContext>
@property (weak, nonatomic) IBOutlet UIView *timeBgV;

@property (nonatomic, strong)UIButton *selectedBtn;

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property (strong) NSString *paymentIntentClientSecret;

@end

@implementation CDSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"订阅服务";
    [StripeAPI setDefaultPublishableKey:@"pk_test_51JFrL6CKjtx6uj2ipbExuLxa8IAUr5LsI2GKSO1259U21gdE5dUbSHbTFwGiolQ2qLdjSLpx7MsNJEKljyAbQvwo00Eqpa6N1O"];
   
    [self getData];
}

-(void)getData{
    [self.view pv_showTextDialog:@"加载中..."];
    [HttpRequest HR_AppListWithParams:nil success:^(id result) {
        [self.view pv_hideMBHub];
        if ([result[@"code"] intValue] == 200) {
            self.dataArr = [CDSubscribeModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [self setUI];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
}

-(void)setUI{
    
    CGFloat btnW = (DEVICE_WIDRH - 79)/self.dataArr.count;
    CGFloat btnH = 50;
    
    for (NSInteger i = 0 ; i < self.dataArr.count; i++) {
        CDSubscribeModel *model = self.dataArr[i];
        
        UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        timeBtn.frame = CGRectMake(btnW * i, 0, btnW, btnH);
        [timeBtn setImage:[UIImage imageNamed:@"quan"] forState:UIControlStateNormal];
        [timeBtn setImage:[UIImage imageNamed:@"quan_selected"] forState:UIControlStateDisabled];
        
        [timeBtn setTitle:model.timeStr forState:UIControlStateNormal];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [timeBtn setTitleColor:[CDHelper getColor:@"777777"] forState:UIControlStateNormal];
        [timeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
        [timeBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        timeBtn.tag = i;
        
        [self.timeBgV addSubview:timeBtn];
        
        if (i == 0) {
            [self timeBtnClick:timeBtn];
        }
    }
    
}

-(void)timeBtnClick:(UIButton *)sender{
    sender.enabled = NO;
    self.selectedBtn.enabled = YES;
    self.selectedBtn = sender;
    
    CDSubscribeModel *model = self.dataArr[sender.tag];
    self.moneyLab.text = [NSString stringWithFormat:@"%ld",model.money/100];
}

//订阅
- (IBAction)subscribe:(id)sender {
    [self startCheckout];
}

- (void)startCheckout {
    
    CDSubscribeModel *model = self.dataArr[self.selectedBtn.tag];
    [CDHelper createOrderWithVC:self model:model];
}

# pragma mark STPAuthenticationContext
- (UIViewController *)authenticationPresentingViewController {
  return self;
}


@end
