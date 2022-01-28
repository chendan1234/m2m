//
//  AddDeviceWiredViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/3.
//

#import "AddDeviceWiredViewController.h"
#import <TuyaSmartActivatorKit/TuyaSmartActivatorKit.h>
#import "AddDeviceSuccessViewController.h"

#import "NetWiredTipView.h"
#import "NetWiredSearchView.h"
#import "NetFiveView.h"

@interface AddDeviceWiredViewController ()<TuyaSmartActivatorDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSString *token;
@property (assign, nonatomic) bool isSuccess;
@property (nonatomic, assign)NSInteger homeId;
@property (nonatomic, strong)UIScrollView *scrollV;

@property (nonatomic, strong)NetWiredSearchView *secondV;

@end

#define KContentHH 530
@implementation AddDeviceWiredViewController

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
    [[TuyaSmartActivator sharedInstance] stopConfigWiFi];
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
    
    self.homeId = [[[NSUserDefaults standardUserDefaults] objectForKey:KHomeId] longValue];
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
    self.scrollV = scrollV;
    
    //入网提示
    NetWiredTipView *fristV = [NetWiredTipView reload];
    fristV.frame = CGRectMake(0, 0, DEVICE_WIDRH, KContentHH);
    [fristV setNextBlcok:^{
        [self goToNextWith:1];
        [self.secondV countTime];
        [self startConfiguration];
    }];
    [scrollV addSubview:fristV];
    
    
    //搜索
    NetWiredSearchView *secondV = [NetWiredSearchView reload];
    secondV.frame = CGRectMake(DEVICE_WIDRH, 0, DEVICE_WIDRH, KContentHH);
    [secondV setNextBlock:^{
        [self goToNextWith:2];
    }];
    self.secondV = secondV;
    [scrollV addSubview:secondV];
    
    //没搜索到
    NetFiveView *fiveV = [NetFiveView reload];
    fiveV.frame = CGRectMake(DEVICE_WIDRH*2, 0, DEVICE_WIDRH, KContentHH);
    [fiveV setResetBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.scrollV addSubview:fiveV];
    self.scrollV.contentSize = CGSizeMake(DEVICE_WIDRH*3, DEVICE_HEIGHT);
    self.myTableView.tableHeaderView = scrollV;
}


-(void)goToNextWith:(NSInteger)index{
    CGPoint point = CGPointMake(DEVICE_WIDRH*index, 0);
    [self.scrollV setContentOffset:point animated:YES];
}



- (void)startConfiguration {
    [[TuyaSmartActivator sharedInstance] getTokenWithHomeId:self.homeId success:^(NSString *result) {
        if (result && result.length > 0) {
            self.token = result;
        }
        [self startConfiguration:self.token];
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:error.localizedDescription];
    }];
}

- (void)startConfiguration:(NSString *)token {
    NSLog(@"----%@",token);
    [TuyaSmartActivator sharedInstance].delegate = self;
    [[TuyaSmartActivator sharedInstance] startConfigWiFiWithToken:token timeout:100];
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
