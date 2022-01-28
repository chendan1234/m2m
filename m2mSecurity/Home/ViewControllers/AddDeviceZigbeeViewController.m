//
//  AddDeviceZigbeeViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/1.
//

#import "AddDeviceZigbeeViewController.h"
#import "NetFirstView.h"
#import "NetSecondView.h"
#import "NetThreeView.h"
#import "NetFourView.h"
#import "NetFiveView.h"
#import "QRView.h"

#import <TuyaSmartActivatorKit/TuyaSmartActivatorKit.h>
#import "AddDeviceSuccessViewController.h"


#define KContentHH 530
@interface AddDeviceZigbeeViewController ()<TuyaSmartActivatorDelegate>

@property (nonatomic, strong)UIScrollView *scrollV;
@property (nonatomic, strong)NetSecondView *secondV;
@property (nonatomic, strong)NetThreeView *threeV;
@property (nonatomic, strong)NetFourView *fourV;

@property (nonatomic, assign)NSInteger homeId;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation AddDeviceZigbeeViewController

- (void)dealloc {
    [self resetScreenBrightness];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopConfigWifi];
}

- (void)stopConfigWifi {
    [TuyaSmartActivator sharedInstance].delegate = nil;
    [[TuyaSmartActivator sharedInstance] stopActiveSubDeviceWithGwId:self.wangGuanModel.devId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"设备配网";
    
    [self setupCongi];
    [self setupUI];
}



-(void)setupCongi{
    [self registNotification];
    self.homeId = [CDHelper getHomeId];
    if (self.homeId <= 0) {
        [CDHelper setupOneBtnAlterWithVC:self title:@"还未创建家庭" message:@"请先前往首页创建家庭, 再添加设备~~~" sure:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

-(void)setupUI{
    
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDRH, DEVICE_HEIGHT - getRectNavAndStatusHight - 80)];
    scrollV.pagingEnabled = YES;
    scrollV.scrollEnabled = NO;
    scrollV.contentSize = CGSizeMake(DEVICE_WIDRH*2, DEVICE_HEIGHT);
    self.scrollV = scrollV;
    
    //提示快闪
    NetFirstView *fristV = [NetFirstView reload];
    fristV.frame = CGRectMake(0, 0, DEVICE_WIDRH, KContentHH);
    fristV.isWangGuan = self.isWangGuan;
    [fristV setNextBlcok:^{
        [self goToNextWith:1];
        [self startConfiguration];
        [self.fourV countTime];
    }];
    [scrollV addSubview:fristV];
    
    
    NetFourView *fourV = [NetFourView reload];
    fourV.frame = CGRectMake(DEVICE_WIDRH*1, 0, DEVICE_WIDRH, KContentHH);
    [fourV setNextBlock:^{
        [self goToNextWith:2];
    }];
    self.fourV = fourV;
    [self.scrollV addSubview:fourV];
    
    NetFiveView *fiveV = [NetFiveView reload];
    fiveV.frame = CGRectMake(DEVICE_WIDRH*2, 0, DEVICE_WIDRH, KContentHH);
    [fiveV setResetBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.scrollV addSubview:fiveV];
    self.scrollV.contentSize = CGSizeMake(DEVICE_WIDRH*4, DEVICE_HEIGHT);
    
    self.myTableView.tableHeaderView = scrollV;
}


-(void)goToNextWith:(NSInteger)index{
    CGPoint point = CGPointMake(DEVICE_WIDRH*index, 0);
    [self.scrollV setContentOffset:point animated:YES];
}


- (void)startConfiguration {
    [TuyaSmartActivator sharedInstance].delegate = self;
    [[TuyaSmartActivator sharedInstance] activeSubDeviceWithGwId:self.wangGuanModel.devId timeout:100];
}




#pragma mark - TuyaSmartActivatorDelegate
-(void)activator:(TuyaSmartActivator *)activator didReceiveDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error {
    if (deviceModel && error == nil) {
        AddDeviceSuccessViewController *successVC = [[AddDeviceSuccessViewController alloc]init];
        successVC.deviceModel = deviceModel;
        [self.navigationController pushViewController:successVC animated:YES];
        
    }
    if (error) {
        [self.view pv_failureLoading:error.localizedDescription];
    }
}


#pragma mark - note
- (void)registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)applicationWillResignActive {
    [self resetScreenBrightness];
}

- (void)applicationWillBecomeActive {
    [self setScreenMaxBrightness];
}

- (void)setScreenMaxBrightness {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)resetScreenBrightness {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}



@end
