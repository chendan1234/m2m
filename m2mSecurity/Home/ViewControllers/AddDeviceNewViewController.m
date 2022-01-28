//
//  AddDeviceNewViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import "AddDeviceNewViewController.h"
#import "NetFirstView.h"
#import "NetSecondView.h"
#import "NetThreeView.h"
#import "NetFourView.h"
#import "NetFiveView.h"

#import "QRView.h"
#import <TuyaSmartActivatorKit/TuyaSmartActivatorKit.h>
#import "AddDeviceSuccessViewController.h"


#define KContentHH 530

@interface AddDeviceNewViewController ()<TuyaSmartActivatorDelegate>

@property (nonatomic, strong)UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NetSecondView *secondV;
@property (nonatomic, strong)NetThreeView *threeV;
@property (nonatomic, strong)NetFourView *fourV;

@property (strong, nonatomic) NSString *token;
@property (assign, nonatomic) bool isSuccess;
@property (nonatomic, assign)NSInteger homeId;

@property (nonatomic, strong)NSString *ssid;
@property (nonatomic, strong)NSString *password;

@end

@implementation AddDeviceNewViewController

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
    scrollV.contentSize = CGSizeMake(DEVICE_WIDRH*2, DEVICE_HEIGHT);
    self.scrollV = scrollV;
    
    //提示快闪
    NetFirstView *fristV = [NetFirstView reload];
    fristV.isWangGuan = self.isWangGuan;
    fristV.frame = CGRectMake(0, 0, DEVICE_WIDRH, KContentHH);
    [fristV setNextBlcok:^{
        [self goToNextWith:1];
    }];
    [scrollV addSubview:fristV];
    
    //输入二维码和密码
    NetSecondView *secondV = [NetSecondView reload];
    secondV.frame = CGRectMake(DEVICE_WIDRH, 0, DEVICE_WIDRH, KContentHH);
    [secondV setNextBlcok:^{
        [self goToNextWith:2];
    }];
    self.secondV = secondV;
    [scrollV addSubview:secondV];
    
    
    if (self.type == 1) {//二维码入网
        [self QR];
    }else{
        [self otherNet];//其他方式入网
    }
    
    self.myTableView.tableHeaderView = scrollV;

    
}


-(void)QR{
    NetThreeView *threeV= [NetThreeView reload];
    threeV.frame = CGRectMake(DEVICE_WIDRH*2, 0, DEVICE_WIDRH, KContentHH);
    [threeV setTipBlcok:^{//听到提示音
        [self goToNextWith:3];
        [self.fourV countTime];
    }];
    self.threeV = threeV;
    [self.scrollV addSubview:threeV];
    
    NetFourView *fourV = [NetFourView reload];
    fourV.frame = CGRectMake(DEVICE_WIDRH*3, 0, DEVICE_WIDRH, KContentHH);
    [fourV setNextBlock:^{
        [self goToNextWith:4];
    }];
    self.fourV = fourV;
    [self.scrollV addSubview:fourV];
    
    NetFiveView *fiveV = [NetFiveView reload];
    fiveV.frame = CGRectMake(DEVICE_WIDRH*4, 0, DEVICE_WIDRH, KContentHH);
    [fiveV setResetBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.scrollV addSubview:fiveV];
    self.scrollV.contentSize = CGSizeMake(DEVICE_WIDRH*5, DEVICE_HEIGHT);
}

//其他方式入网, 包括EZ, Zigbee
-(void)otherNet{
    NetFourView *fourV = [NetFourView reload];
    fourV.frame = CGRectMake(DEVICE_WIDRH*2, 0, DEVICE_WIDRH, KContentHH);
    [fourV setNextBlock:^{
        [self goToNextWith:3];
    }];
    self.fourV = fourV;
    [self.scrollV addSubview:fourV];
    
    NetFiveView *fiveV = [NetFiveView reload];
    fiveV.frame = CGRectMake(DEVICE_WIDRH*3, 0, DEVICE_WIDRH, KContentHH);
    [fiveV setResetBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.scrollV addSubview:fiveV];
    self.scrollV.contentSize = CGSizeMake(DEVICE_WIDRH*4, DEVICE_HEIGHT);
    
    
}

-(void)goToNextWith:(NSInteger)index{
    if (self.type == 1 && index == 2) {//二维码入网模式
        if (self.secondV.wifiTF.text.length && self.secondV.passwordTF.text.length){
            self.ssid = self.secondV.wifiTF.text;
            self.password = self.secondV.passwordTF.text;
            [self startConfiguration];
            [self.view pv_showTextDialog:@"正在生成二维码..."];
        }else{
            [self.view pv_warming:@"请输入WiFi名称和WiFi密码!"];
            return;
        }
    }
    
    if (self.type == 2 && index == 2) {//其他方式
        [self.fourV countTime];
        [self prepare];
    }
    
    CGPoint point = CGPointMake(DEVICE_WIDRH*index, 0);
    [self.scrollV setContentOffset:point animated:YES];
}

//快连模式
-(void)prepare{
    if (self.secondV.wifiTF.text.length && self.secondV.passwordTF.text.length){
        self.ssid = self.secondV.wifiTF.text;
        self.password = self.secondV.passwordTF.text;
        [self startConfiguration];
    }else{
        [self.view pv_warming:@"请输入WiFi名称和WiFi密码!"];
    }
}

- (void)startConfiguration {
//    long long homeId = [[[NSUserDefaults standardUserDefaults] objectForKey:KHomeId] longValue];
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
    
    NSString *ssid = self.ssid;
    NSString *password = self.password;
    [TuyaSmartActivator sharedInstance].delegate = self;
    
    if (self.type == 1) {//二维码入网
        [self.view pv_hideMBHub];
        [self.threeV setupQRWithWifiName:self.ssid password:self.password token:token];
        [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeQRCode ssid:ssid password:password token:token timeout:100];
    }else{//快连
        [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeEZ ssid:ssid password:password token:self.token timeout:100];
    }
    
    
    
}


#pragma mark - TuyaSmartActivatorDelegate
-(void)activator:(TuyaSmartActivator *)activator didReceiveDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error {
    
    if (deviceModel && error == nil) {
        self.isSuccess = YES;
        [[NSUserDefaults standardUserDefaults]setObject:self.ssid forKey:KWiFiName];
        [[NSUserDefaults standardUserDefaults]setObject:self.password forKey:KWiFiPassword];
        
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
