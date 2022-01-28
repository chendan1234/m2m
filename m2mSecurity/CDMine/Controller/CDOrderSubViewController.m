//
//  CDOrderSubViewController.m
//  Security
//
//  Created by chendan on 2021/8/4.
//

#import "CDOrderSubViewController.h"
#import "CDOrderDetailViewController.h"
#import "CDCommonDefine.h"
#import "HttpRequest.h"
#import "CDHelper.h"
#import "UIView+ProgressView.h"
#import <MJExtension.h>

#import "CDOrderBtnCell.h"
#import "CDOrderLabCell.h"


#import "OYCountDownManager.h"

@interface CDOrderSubViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, assign)NSInteger page;

@property (nonatomic, strong)NSMutableArray *timeArr;

@property (nonatomic, strong)NSString *totalCount;

@end

static NSString *btnCellID = @"btnCellID";
static NSString *labCellID = @"labCellID";

@implementation CDOrderSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setUI];
    
    self.page = 1;
    [self getData];
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getData];
    }];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getData];
    }];
    
    // 启动倒计时管理
    [kCountDownManager start];
}

-(void)setUI{
    [self.myTableView registerNib:[UINib nibWithNibName:@"CDOrderBtnCell" bundle:nil] forCellReuseIdentifier:btnCellID];
    [self.myTableView registerNib:[UINib nibWithNibName:@"CDOrderLabCell" bundle:nil] forCellReuseIdentifier:labCellID];
    self.timeArr = [[NSMutableArray alloc]init];
    [self.myTableView addNoteViewWithpicName:@"noOrder" noteText:@"" refreshBtnImg:nil orginY:120];
}

-(void)getData{
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"page"] = @(self.page);
    parames[@"size"] = @(10);
    parames[@"userId"] = [[NSUserDefaults standardUserDefaults]objectForKey:KUserId];
    if (self.type) {
        parames[@"status"] = @(self.type);
    }
    
    
    
    if (self.totalCount && [self.totalCount intValue] <= self.dataArr.count) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        return;
    }
    
    [self.view pv_showTextDialog:@"正在加载..."];
    [HttpRequest HR_OrderAppListWithParams:parames success:^(id result) {
        NSLog(@"订单列表---%@",result);
        if ([result[@"code"] intValue] == 200) {
            [self.view pv_hideMBHub];
            
            if (self.page == 1) {
                self.dataArr = [CDOrderModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"data"]];
            }else{
                NSArray *list = [CDOrderModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"data"]];
                [self.dataArr addObjectsFromArray:list];
            }
            
            [kCountDownManager reload];
            [self.myTableView reloadData];
            
            self.totalCount = [NSString stringWithFormat:@"%d",[result[@"data"][@"totalCount"] intValue]];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
        
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CDOrderModel *model = self.dataArr[indexPath.row];
    if (model.status == 1 || model.status == 2) {
        CDOrderBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:btnCellID];
        cell.model = model;
        return cell;
    }else{
        CDOrderLabCell *cell = [tableView dequeueReusableCellWithIdentifier:labCellID];
        cell.model = model;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDOrderModel *model = self.dataArr[indexPath.row];
    if (model.status == 1 || model.status == 2) {
        return 200;
    }else{
        return 146;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CDOrderModel *model = self.dataArr[indexPath.row];
    
    CDOrderDetailViewController *orderDetailVC = [[CDOrderDetailViewController alloc]init];
    orderDetailVC.orderId = model.orderId;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)dealloc {
    // 废除定时器
    [kCountDownManager invalidate];
    // 清空时间差
    [kCountDownManager reload];
}





@end
