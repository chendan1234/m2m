//
//  ChildListViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "ChildListViewController.h"
#import "ChildListCell.h"

#import "DeviceDetailViewController.h"

@interface ChildListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)TuyaSmartDevice *device;


@end

static NSString *cellID = @"cellID";
@implementation ChildListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"子设备列表";
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    
    [self setupTableView];
    [self getData];
}

-(void)setupTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:@"ChildListCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 70;
    self.myTableView.contentInset = UIEdgeInsetsMake(16, 0, 0, 0);
    
    [self.myTableView addNoteViewWithpicName:@"noDevice" noteText:@"" refreshBtnImg:nil orginY:120];
}

-(void)getData{
    [self.view pv_showTextDialog:@"加载中..."];
    [self.device  getSubDeviceListFromCloudWithSuccess:^(NSArray<TuyaSmartDeviceModel *> * _Nonnull subDeviceList) {
        [self.view pv_hideMBHub];
        self.dataArr = subDeviceList;
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        [self.view pv_hideMBHub];
        [CDHelper setupOneBtnAlterWithVC:self title:@"子设备获取失败" message:@"子设备获取失败, 请退出后重新进入" sure:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChildListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceDetailViewController *detailVC = [[DeviceDetailViewController alloc]init];
    detailVC.deviceModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
