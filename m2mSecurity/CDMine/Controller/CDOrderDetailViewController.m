//
//  CDOrderDetailViewController.m
//  Security
//
//  Created by chendan on 2021/8/4.
//

#import "CDOrderDetailViewController.h"
#import "CDCommonDefine.h"
#import "HttpRequest.h"
#import "CDCommonDefine.h"
#import "UIView+ProgressView.h"
#import <MJExtension.h>
#import "CDHelper.h"
#import "CDOrderDetailModel.h"
#import "CDOrderInfoCell.h"
#import "CDRefundViewController.h"
#import "CDSubscribeModel.h"

@interface CDOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong)CDOrderDetailModel *model;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

static NSString *cellID = @"cellID";
@implementation CDOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setStatusBarBackgroundColor:[CDHelper getColor:@"3292F6"]];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar;
        if (@available(iOS 13.0, *))
        {
            UIWindow *keyWindow = [UIApplication sharedApplication].windows[0];
            statusBar = [[UIView alloc]initWithFrame:keyWindow.windowScene.statusBarManager.statusBarFrame] ;
            [keyWindow addSubview:statusBar];
        }
        else
        {
           statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        }
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = color;
        }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"订单详情";
    
    [self getData];
    
    
}

-(void)getData{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"orderId"] = self.orderId;
    
    [self.view pv_showTextDialog:@"正在加载..."];
    [HttpRequest HR_OrderAppInfoWithContent:self.orderId Params:parames success:^(id result) {
        NSLog(@"订单详情 --- %@",result);
        if ([result[@"code"] intValue] == 200) {
            [self.view pv_hideMBHub];
            self.model = [CDOrderDetailModel mj_objectWithKeyValues:result[@"data"]];
            self.dataArr = [[NSMutableArray alloc]init];
            NSArray *arr = [self.model.orderInfo componentsSeparatedByString:@"/n"];
            for (NSString *info in arr) {
                if (info.length) {
                    [self.dataArr addObject:info];
                }
            }
            
            [self setUI];
            [self.myTableView reloadData];
            
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
}

-(void)setUI{
    [self.myTableView registerNib:[UINib nibWithNibName:@"CDOrderInfoCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 26;
    self.myTableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    
    
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号: %@",self.model.orderNumber];
    self.serviceNameLab.text = self.model.serviceName;
    self.moneyLab.text = [NSString stringWithFormat:@"实付: %ld",self.model.money];
    self.serviceTimeLab.text = [CDHelper getServiceDayWith:self.model.life];
    self.timeLab.text = [CDHelper time_timestampToString:self.model.createTime/1000];
    
    switch (self.model.status) {//状态：1：待付款 2：服务中 3：待审核 4：退款中 5：已过期 6：已关闭 7：拒绝退款
        case 1:
        {
            self.statusLab.text = @"待付款";
            self.actionBtn.hidden = NO;
        }
            break;
        case 2:
        {
            self.statusLab.text = @"服务中";
            [self.actionBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.actionBtn.hidden = NO;
        }
            break;
        case 3:
        {
            self.statusLab.text = @"待审核";
        }
            break;
        case 4:
        {
            self.statusLab.text = @"退款中";
        }
            break;
        case 5:
        {
            self.statusLab.text = @"已过期";
            break;
        }
        case 6:
        {
            self.statusLab.text = @"已关闭";
            break;
        }
        case 7:
        {
            self.statusLab.text = @"拒绝退款";
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.infoLab.text = self.dataArr[indexPath.row];
    return cell;
}

- (IBAction)actionBtnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqual:@"申请退款"]) {//
        CDRefundViewController *refundVC = [[CDRefundViewController alloc]init];
        refundVC.detailModel = self.model;
        [self.navigationController pushViewController:refundVC animated:YES];
    }else{//付款
        CDSubscribeModel *model = [[CDSubscribeModel alloc]init];
        model.serviceName = self.model.serviceName;
        model.serviceDay = self.model.life;
        model.money = self.model.money * 100;
        [CDHelper createOrderWithVC:self model:model];
    }
}


@end
