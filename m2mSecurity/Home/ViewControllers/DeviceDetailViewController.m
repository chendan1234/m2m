//
//  DeviceDetailViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/27.
//

#import "DeviceDetailViewController.h"
#import "DeviceDetailCell.h"
#import "DeviceDetailTopView.h"
#import "DeviceDetailHeaderView.h"
#import "DeviceInfoViewController.h"
#import "DeviceLogListModel.h"
#import <LSTPopView.h>
#import "SelectTimeView.h"

@interface DeviceDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartDeviceDelegate,TuyaSmartHomeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSInteger selectDay;//1,2,7
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSString *dpIds;
@property (nonatomic, strong)NSMutableDictionary *dpDic;
@property (nonatomic, strong)UILabel *timeLab;

@property (nonatomic, strong)TuyaSmartDevice *device;

@property (nonatomic, strong)DeviceDetailHeaderView *headerView;

@end

static NSString *cellID = @"cellID";
@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.deviceModel.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(moreInfo)];
    [self setupData];
    [self setupTableView];
    
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.device.delegate = self;
}

- (void)device:(TuyaSmartDevice *)device dpsUpdate:(NSDictionary *)dps {
    // 设备的 dps 状态发生变化，刷新界面 UI
    self.headerView.model = self.deviceModel;
}



- (void)getOperationLogList {
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"devId"] = self.deviceModel.devId;
    parames[@"dpIds"] = self.dpIds;
    parames[@"offset"] = @(self.page * 10);
    parames[@"limit"] = @(10);
    parames[@"sortType"] = @"DESC";
    parames[@"startTime"] = [CDHelper getBeforeTimeStrapWithDay:self.selectDay];
    parames[@"endTime"] = [CDHelper getCurrentTimeStrap];

  [[TuyaSmartRequest new] requestWithApiName:@"tuya.m.smart.operate.all.log" postData:parames version:@"1.0" success:^(id result) {
      if (self.page == 0) {
          self.dataArr = [self dealDataWith:result];
      }else{
          [self.dataArr addObjectsFromArray:[self dealDataWith:result]];
      }
      [self.myTableView.mj_header endRefreshing];
      [self.myTableView.mj_footer endRefreshing];
      [self.myTableView reloadData];
  } failure:^(NSError *error) {
      [self getOperationLogList];
  }];
}

-(NSMutableArray *)dealDataWith:(id)result{
    NSMutableArray *dataArr = [DeviceLogListModel mj_objectArrayWithKeyValuesArray:result[@"dps"]];
    for (DeviceLogListModel *model in dataArr) {
        model.name = self.dpDic[model.dpId];
    }
    return  dataArr;
}



-(void)moreInfo{
    DeviceInfoViewController *infoVC = [[DeviceInfoViewController alloc]init];
    infoVC.isChild = YES;
    infoVC.deviceModel = self.deviceModel;
    
    if ([CDHelper isShengGuangWithModel:self.deviceModel]) {
        infoVC.form = DeviceInfoFormShengGuang;
    }else{
        infoVC.form = DeviceInfoFormDefault;
    }
    [self.navigationController pushViewController:infoVC animated:YES];
}

-(void)setupTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:@"DeviceDetailCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 68;
    
    CGFloat headerViewH = 329;
    if ([CDHelper getDeviceCategoryWithModel:self.deviceModel] == DeviceCategroyCDYanGan || [CDHelper getDeviceCategoryWithModel:self.deviceModel] == DeviceCategroyCDShengGuang) {
        headerViewH = 359;
    }
    
    DeviceDetailHeaderView *headerView = [DeviceDetailHeaderView reload];
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDRH, headerViewH);
    headerView.model = self.deviceModel;
    
    self.headerView = headerView;
    
    UIView *headerV = [[UIView alloc]initWithFrame:headerView.bounds];
    [headerV addSubview:headerView];
    
    self.myTableView.tableHeaderView = headerV;
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self getOperationLogList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getOperationLogList];
    }];
    
    self.selectDay = 1;
    [self.myTableView.mj_header beginRefreshing];
    [self.myTableView addNoteViewWithpicName:@"noRiZhi" noteText:@"" refreshBtnImg:nil orginY:450];
}

-(void)setupData{
    NSMutableArray *dps = [[NSMutableArray alloc] init];
    self.dpDic = [NSMutableDictionary dictionary];
    for (TuyaSmartSchemaModel *model in self.deviceModel.schemaArray) {
        [dps addObject:model.dpId];
        self.dpDic[model.dpId] = model.name;
    }
    self.dpIds = [dps componentsJoinedByString:@","];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArr[indexPath.row];
    cell.deviceModel = self.deviceModel;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DeviceDetailTopView *topV = [DeviceDetailTopView reload];
    topV.frame = CGRectMake(0, 0, DEVICE_WIDRH, 50);
    [topV.selectTimeBtn addTarget:self action:@selector(selectTime) forControlEvents:UIControlEventTouchUpInside];
    topV.day = self.selectDay;
    return topV;
}

- (void)selectTime {
    SelectTimeView *view = [SelectTimeView reload];
    view.frame = CGRectMake(0, DEVICE_HEIGHT - 210, DEVICE_WIDRH, 210);
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;
    LSTPopView *popView = [LSTPopView initWithCustomView:view popStyle:LSTPopStyleSpringFromBottom dismissStyle:LSTDismissStyleSmoothToBottom];
    LSTPopViewWK(popView)
    popView.hemStyle = LSTHemStyleBottom;
    popView.popDuration = 0.25;
    popView.dismissDuration = 0.5;
    popView.isClickFeedback = YES;
    
    [view setSelectTimeBlock:^(NSInteger day) {
        [wk_popView dismiss];
        self.selectDay = day;
        [self.myTableView.mj_header beginRefreshing];
    }];
    
    [view setCancelBlock:^{
        [wk_popView dismiss];
    }];
    
    [popView pop];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}







@end
