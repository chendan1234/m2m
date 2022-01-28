//
//  HomeManageViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import "HomeManageViewController.h"
#import "HomeManageCell.h"
#import "HomeDeleteViewController.h"

@interface HomeManageViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(strong, nonatomic) TuyaSmartHomeManager *homeManager;
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(assign, nonatomic) double longitude;
@property(assign, nonatomic) double latitude;
@property(nonatomic, strong)NSArray *homeList;

@end

static NSString *cellID = @"cellID";
@implementation HomeManageViewController

- (TuyaSmartHomeManager *)homeManager {
    if (!_homeManager) {
        _homeManager = [[TuyaSmartHomeManager alloc] init];
    }
    return _homeManager;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"家庭管理";
    [self.myTableView registerNib:[UINib nibWithNibName:@"HomeManageCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 50;
    [self.myTableView addNoteViewWithpicName:@"noHome" noteText:@"" refreshBtnImg:nil orginY:120];
    
    [self location];
    [self getHomeList];
}

-(void)location{
    [self.locationManager requestWhenInUseAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingHeading];
    } else {
        NSLog(@"没有获取到位置...");
    }
}

- (IBAction)buildHome:(id)sender {
    [CDHelper setupTFAlertWithVC:self title:@"家庭名称" placeHolder:@"请输入家庭名称" sure:^(NSString * _Nonnull tf) {
        [self addHomeWithHomeName:tf];
    }];
}

- (void)getHomeList {
    __weak typeof(self) weakSelf = self;
    
    [self.view pv_showTextDialog:@"正在获取家庭列表..."];
    [self.homeManager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        // homes 家庭列表
        weakSelf.homeList = homes;
        [weakSelf.view pv_hideMBHub];
        [weakSelf.myTableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.view pv_failureLoading:@"家庭列表获取失败!"];
    }];
}

-(void)addHomeWithHomeName:(NSString *)homeName{
    __weak typeof(self) weakSelf = self;
    [self.view pv_showTextDialog:@"正在添加家庭..."];
    [self.homeManager addHomeWithName:homeName geoName:@"" rooms:@[@""] latitude:self.latitude longitude:self.longitude success:^(long long result) {
        [weakSelf getHomeList];
        [CDHelper bindDefaultChannel];//创建家庭成功后, 绑定服务商
    } failure:^(NSError *error) {
        [weakSelf.view pv_failureLoading:error.localizedDescription];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.homeList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.homeList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeDeleteViewController *deleteVC = [[HomeDeleteViewController alloc]init];
    deleteVC.model = self.homeList[indexPath.row];
    [deleteVC setDeleteBlock:^(TuyaSmartHomeModel * _Nonnull model) {
        [self getHomeList];
        
        NSNumber *homeId = [[NSUserDefaults standardUserDefaults]objectForKey:KHomeId];
        if ([homeId longValue] == model.homeId ) {
            if (self.deleteSelectBlock) {
                self.deleteSelectBlock();
            }
        }
    }];
    [self.navigationController pushViewController:deleteVC animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = manager.location;
    if (!location) {
        return;
    }
    
    self.longitude = location.coordinate.longitude;
    self.latitude = location.coordinate.latitude;
}



@end
