//
//  TextViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/3.
//

#import "TextViewController.h"

@interface TextViewController ()<TuyaSmartDeviceDelegate>

@property (nonatomic, strong)TuyaSmartDevice *device;

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"devId == %@",self.deviceModel.devId);
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.device.delegate = self;
    [self.device getWifiSignalStrengthWithSuccess:^{
        NSLog(@"成功");
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}

-(void)device:(TuyaSmartDevice *)device signal:(NSString *)signal{
    NSLog(@" signal : %@", signal);
}


@end
