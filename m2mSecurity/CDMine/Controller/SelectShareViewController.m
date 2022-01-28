//
//  SelectShareViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "SelectShareViewController.h"
#import "SelectUserShareViewController.h"
#import "MoreShareCell.h"


@interface SelectShareViewController ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartHomeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) TuyaSmartHome *home;
@property (nonatomic, strong)NSMutableArray *dataArr;

@end

static NSString *cellID = @"cellID";
@implementation SelectShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择共享设备";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MoreShareCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 70;
    self.myTableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    [self.myTableView addNoteViewWithpicName:@"noDevice" noteText:@"" refreshBtnImg:nil orginY:120];
    
    
    
    self.home = [TuyaSmartHome homeWithHomeId:[CDHelper getHomeId]];
    if (self.home.deviceList.count) {
        self.dataArr = [[NSMutableArray alloc]init];
        for (TuyaSmartDeviceModel *model in self.home.deviceList) {
            MoreShareDeviceModel *deviceModel = [[MoreShareDeviceModel alloc]init];
            deviceModel.model = model;
            [self.dataArr addObject:deviceModel];
        }
    }else{
        [self getAllDevice];
    }
    
}

-(void)next{
    
    NSMutableArray *shareArr = [[NSMutableArray alloc]init];
    for (MoreShareDeviceModel *deviceModel in self.dataArr) {
        if (deviceModel.isSelected) {
            [shareArr addObject:deviceModel.model];
        }
    }
    
    if (shareArr.count) {
        SelectUserShareViewController *userVC = [[SelectUserShareViewController alloc]init];
        userVC.deviceArr = shareArr;
        [self.navigationController pushViewController:userVC animated:YES];
    }else{
        [self.view pv_warming:@"请选择共享设备!"];
    }
    
}

//获取我的设备
-(void)getAllDevice{
    self.home = [TuyaSmartHome homeWithHomeId:[CDHelper getHomeId]];
    self.home.delegate = self;
    [self.view pv_showTextDialog:@"加载中..."];
    [self updateHomeDetail];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreShareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreShareDeviceModel *deviceModel = self.dataArr[indexPath.row];
    deviceModel.isSelected = !deviceModel.isSelected;
    [self.myTableView reloadData];
}

#pragma mark -----device-----
- (void)updateHomeDetail {
    [self.home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
        [self.view pv_hideMBHub];
        [self reload];
    } failure:^(NSError *error) {
        [self.view pv_hideMBHub];
        [CDHelper setupAlterWithVC:self title:NSLocalizedString(@"Failed to Fetch Home", @"") message:error.localizedDescription sure:^{}];
    }];
}

- (void)homeDidUpdateInfo:(TuyaSmartHome *)home {
    [self reload];
}

-(void)home:(TuyaSmartHome *)home didAddDeivice:(TuyaSmartDeviceModel *)device {
    [self reload];
}

-(void)home:(TuyaSmartHome *)home didRemoveDeivice:(NSString *)devId {
    [self reload];
}

-(void)home:(TuyaSmartHome *)home deviceInfoUpdate:(TuyaSmartDeviceModel *)device {
    [self reload];
}

-(void)home:(TuyaSmartHome *)home device:(TuyaSmartDeviceModel *)device dpsUpdate:(NSDictionary *)dps {
    [self reload];
}

-(void)reload{
    
    self.dataArr = [[NSMutableArray alloc]init];
    for (TuyaSmartDeviceModel *model in self.home.deviceList) {
        MoreShareDeviceModel *deviceModel = [[MoreShareDeviceModel alloc]init];
        deviceModel.model = model;
        [self.dataArr addObject:deviceModel];
    }
    
    [self.myTableView reloadData];
    [self.myTableView.mj_header endRefreshing];
}



@end
