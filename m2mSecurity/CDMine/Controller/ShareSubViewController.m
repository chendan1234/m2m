//
//  ShareSubViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "ShareSubViewController.h"
#import "MyDeviceCell.h"
#import "MyShareCell.h"
#import "SelectUserShareViewController.h"
#import "Home.h"
#import "MyShareUserCell.h"
#import "ShareDeviceLlistViewController.h"


@interface ShareSubViewController ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartHomeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(strong, nonatomic) TuyaSmartHomeManager *homeManager;
@property (strong, nonatomic) TuyaSmartHome *home;

@property (nonatomic, strong)NSArray *dataArr;

@property (nonatomic, strong)TuyaSmartHomeDeviceShare *deviceShare;

@end


static NSString *cellID = @"cellID";
@implementation ShareSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.deviceShare = [[TuyaSmartHomeDeviceShare alloc]init];
    self.home = [TuyaSmartHome homeWithHomeId:[CDHelper getHomeId]];
    [self setupTableView];
}

-(void)setupTableView{
    
    if (self.type == 1) {
        [self.myTableView registerNib:[UINib nibWithNibName:@"MyDeviceCell" bundle:nil] forCellReuseIdentifier:cellID];
    }else{
        [self.myTableView registerNib:[UINib nibWithNibName:@"MyShareUserCell" bundle:nil] forCellReuseIdentifier:cellID];
    }
    
    
    self.myTableView.rowHeight = 70;
    self.myTableView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
    [self.myTableView addNoteViewWithpicName:@"noDevice" noteText:@"" refreshBtnImg:nil orginY:120];
    
    if ([CDHelper getHomeId] <= 0) {
        [CDHelper setupOneBtnAlterWithVC:self title:@"还未创建家庭" message:@"请先前往首页创建家庭, 再共享设备~~~" sure:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else{
        self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
        }];
        [self.myTableView.mj_header beginRefreshing];
    }
}

-(void)getData{
    switch (self.type) {
        case 1:
            [self getAllDevice];
            break;
        case 2:
        {
            [self.home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
                [self getShareDevice];
            } failure:^(NSError *error) {
                [CDHelper setupAlterWithVC:self title:NSLocalizedString(@"Failed to Fetch Home", @"") message:error.localizedDescription sure:^{}];
            }];
        }
            break;
        case 3:
        {
            [self.home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
                [self getShareNoti];
            } failure:^(NSError *error) {
                [CDHelper setupAlterWithVC:self title:NSLocalizedString(@"Failed to Fetch Home", @"") message:error.localizedDescription sure:^{}];
            }];
        }
    
            break;

        default:
            break;
    }
}



//获取我的设备
-(void)getAllDevice{
    self.home.delegate = self;
    [self updateHomeDetail];
}

//获取我的共享 (我分享给别人)
-(void)getShareDevice{
    [self.deviceShare getShareMemberListWithHomeId:[CDHelper getHomeId] success:^(NSArray<TuyaSmartShareMemberModel *> *list) {
        self.dataArr = list;
        [self.myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self getShareDevice];
    }];
}

//获取共享消息(别人分享给我)
-(void)getShareNoti{
    [self.deviceShare getReceiveMemberListWithSuccess:^(NSArray<TuyaSmartShareMemberModel *> *list) {
        self.dataArr = list;
        [self.myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self getShareNoti];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 1) {
        return self.home?self.home.deviceList.count:0;
    }else{
        return self.dataArr.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        MyDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.model = self.home.deviceList[indexPath.row];
        return cell;
    }else{
        MyShareUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.userModel = self.dataArr[indexPath.row];
        cell.type = self.type;
        [cell setDeleteBlock:^{
            [self getData];
        }];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {//去共享设备
        SelectUserShareViewController *userVC = [[SelectUserShareViewController alloc]init];
        userVC.deviceArr = @[self.home.deviceList[indexPath.row]];
        [self.navigationController pushViewController:userVC animated:YES];
    }else{//别人共享给我
        ShareDeviceLlistViewController *deviceVC = [[ShareDeviceLlistViewController alloc]init];
        deviceVC.model = self.dataArr[indexPath.row];
        deviceVC.type = self.type;
        [deviceVC setDeleteBlock:^{
            [self.myTableView.mj_header beginRefreshing];
        }];
        [self.navigationController pushViewController:deviceVC animated:YES];
    }
}


#pragma mark -----device-----
- (void)updateHomeDetail {
    [self.home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
        [self reload];
    } failure:^(NSError *error) {
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
    [self.myTableView reloadData];
    [self.myTableView.mj_header endRefreshing];
}

@end
