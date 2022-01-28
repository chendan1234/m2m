//
//  CDDevicelistViewController.m
//  Security
//
//  Created by chendan on 2021/7/7.
//

#import "CDDevicelistViewController.h"
#import "CDDevicelistCell.h"
#import "CDDeviceListCollectionCell.h"
#import "CDCommonDefine.h"
#import "ScanViewController.h"
#import "DeviceDetailViewController.h"
#import "CameraViewController.h"

#import "TextViewController.h"

#import "UITableView+Empty.h"
#import "UICollectionView+Empty.h"
#import "Home.h"
#import <TuyaSmartDefaultPanelKit/TuyaSmartDefaultPanelKit.h>
#import "DeviceInfoViewController.h"

#import "MenLingViewController.h"




@interface CDDevicelistViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,TuyaSmartHomeDelegate>
{
    NSMutableArray *deviceArray; //设备信息数组
    int selectNum;               //当前选择的设置
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property(strong, nonatomic) TuyaSmartHomeManager *homeManager;
@property (strong, nonatomic) TuyaSmartHome *home;
@property (nonatomic, assign)NSInteger homeId;


@end

static NSString *tebleCellID = @"tebleCellID";
static NSString *collectionCellID = @"collectionCellID";
@implementation CDDevicelistViewController

- (TuyaSmartHomeManager *)homeManager {
    if (!_homeManager) {
        _homeManager = [[TuyaSmartHomeManager alloc] init];
    }
    return _homeManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setupTableView];
    [self setupCollectionView];
    
    if (self.type == 2) {//共享设备 不加没有刷新控件
        [self setupHomeDevice];
    }
}

-(void)setupHomeDevice{
    
    self.homeId = [CDHelper getHomeId];
    
    if (self.homeId == 0) {//清除所有设备
        self.home = nil;
        [self reload];
        return;
    }
    
    self.home = [TuyaSmartHome homeWithHomeId:self.homeId];
    self.home.delegate = self;
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateHomeDetail];
    }];
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateHomeDetail];
    }];
    
    [self.myCollectionView.mj_header beginRefreshing];
    [self.myTableView.mj_header beginRefreshing];
    
}


- (void)exchangeLayout:(BOOL)isTableView{
    self.myTableView.hidden = !isTableView;
    self.myCollectionView.hidden = isTableView;
}


-(void)setupTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:@"CDDevicelistCell" bundle:nil] forCellReuseIdentifier:tebleCellID];
    self.myTableView.rowHeight = 71;
    self.myTableView.hidden = YES;
    [self.myTableView addNoteViewWithpicName:@"noDevice" noteText:@"" refreshBtnImg:nil orginY:50];
}

-(void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat itemW = (DEVICE_WIDRH - 36)/2;
    layout.itemSize = CGSizeMake(itemW, 106);
    layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    
    self.myCollectionView.collectionViewLayout = layout;
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"CDDeviceListCollectionCell" bundle:nil] forCellWithReuseIdentifier:collectionCellID];
    self.myCollectionView.hidden = NO;
    [self.myCollectionView addNoteViewWithpicName:@"noDevice" noteText:@"" refreshBtnImg:nil orginY:50];
}


#pragma mark -----tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 1) {//全部设备
        return self.home?self.home.deviceList.count:0;
    }else{//共享设备
        return self.home?self.home.sharedDeviceList.count:0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDDevicelistCell *cell = [tableView dequeueReusableCellWithIdentifier:tebleCellID];
    cell.model = self.type == 1 ? self.home.deviceList[indexPath.row] : self.home.sharedDeviceList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goToDetailWithRow:indexPath.row];
}

#pragma mark -----collectionView-----
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.type == 1) {//全部设备
        return self.home?self.home.deviceList.count:0;
    }else{//共享设备
        return self.home?self.home.sharedDeviceList.count:0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CDDeviceListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    cell.model = self.type == 1 ? self.home.deviceList[indexPath.row] : self.home.sharedDeviceList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self goToDetailWithRow:indexPath.row];
}

-(void)goToDetailWithRow:(NSInteger)row{
    NSString *deviceID = self.type == 1?self.home.deviceList[row].devId:self.home.sharedDeviceList[row].devId;
    TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:deviceID];
    
    // 取出TuyaSmartDeviceModel,判断是不是IPC设备
    TuyaSmartDeviceModel *deviceModel = device.deviceModel;
    if (deviceModel.isIPCDevice) {
//        CameraViewController *vc = [[CameraViewController alloc] initWithDeviceId:deviceModel.devId];
//        [self.navigationController pushViewController:vc animated:YES];
        
        MenLingViewController *menLingVC = [[MenLingViewController alloc]initWithDeviceId:deviceModel.devId];
        menLingVC.deviceModel = deviceModel;
        [self.navigationController pushViewController:menLingVC animated:YES];
        
    } else {
        if ([CDHelper isWangGuan2:deviceModel]) {//网关
            DeviceInfoViewController *infoVC = [[DeviceInfoViewController alloc]init];
            infoVC.deviceModel = deviceModel;
            infoVC.form = DeviceInfoFormWangGuan;
            [self.navigationController pushViewController:infoVC animated:YES];
        }else{
            DeviceDetailViewController *detailVC = [[DeviceDetailViewController alloc]init];
            detailVC.deviceModel = deviceModel;
            [CDHelper setDeviceCategoryWithCategory:deviceModel.category];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
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
    
    if (self.stateBlock && self.type == 1) {
        self.stateBlock();
    }
    
    [self.myTableView reloadData];
    [self.myCollectionView reloadData];
    
    [self.myCollectionView.mj_header endRefreshing];
    [self.myTableView.mj_header endRefreshing];
    
    if (self.type == 1) {//我自己的设备, 判断网关
        for (TuyaSmartDeviceModel *model in self.home.deviceList) {//判断列表中是否有一个网关, 一个家庭允许添加一个网关
            if ([CDHelper isWangGuan2:model]) {//网关
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KIsHaveWangGuan];
                return;
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KIsHaveWangGuan];
            }
        }
        
        if (self.home.deviceList.count == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KIsHaveWangGuan];
        }
    }
}




@end
