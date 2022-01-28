//
//  DeviceWangGuanInfoView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/16.
//

#import "DeviceWangGuanInfoView.h"
#import "ChildListViewController.h"
#import "SelectUserShareViewController.h"
#import "ShuXingView.h"
#import "LSTPopView.h"

@interface DeviceWangGuanInfoView ()

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@property (weak, nonatomic) IBOutlet UILabel *ipLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *statusView;//主机状态

@property (weak, nonatomic) IBOutlet UISwitch *kaiGuanSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *resetSwitch;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@property (nonatomic, strong)TuyaSmartDevice *device;

@end

#define TowLineH 245
@implementation DeviceWangGuanInfoView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"DeviceWangGuanInfoView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.nameView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameViewClick)]];
    [self.shareView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewClick)]];
    [self.childView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(childViewClick)]];
    
    [self.statusView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(statusViewClick)]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    });
    
    [self.resetSwitch addTarget:self action:@selector(resetSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.kaiGuanSwitch addTarget:self action:@selector(kaiGuanSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
}

//恢复出厂设置
-(void)resetSwitchClick:(UISwitch *)sender{
    NSDictionary *dps = @{@"34": @(sender.on)}; //开关
    [self.device publishDps:dps success:^{
        [[CDHelper viewControllerWithView:self].view pv_successLoading:@"修改成功!"];
    } failure:^(NSError *error) {
        [self failChangeShuXingWithTitle:@"报警开关"];
    }];
}

//报警开关
-(void)kaiGuanSwitchClick:(UISwitch *)sender{
    NSDictionary *dps = @{@"4": @(sender.on)}; //开关
    [self.device publishDps:dps success:^{
        [[CDHelper viewControllerWithView:self].view pv_successLoading:@"修改成功!"];
    } failure:^(NSError *error) {
        [self failChangeShuXingWithTitle:@"报警开关"];
    }];
}

//主机状态
-(void)statusViewClick{
    NSArray *dataArr = @[@"normal",@"alarm"];
    NSString *title = @"主机状态";
    [CDHelper setupShuXingTanKuangWith:dataArr viewH:TowLineH title:title selectBlock:^(NSString * _Nonnull selectValue) {
        NSDictionary *dps = @{ @"32" : selectValue }; //亮度
        [self.device publishDps:dps success:^{
            self.statusLab.text = selectValue;
        } failure:^(NSError *error) {
            [self failChangeShuXingWithTitle:title];
        }];
    }];
}

//修改属性失败
-(void)failChangeShuXingWithTitle:(NSString *)title{
    [CDHelper setupOneBtnAlterWithVC:[CDHelper viewControllerWithView:self] title:title message:@"该状态修改失败, 请退出重试" sure:^{
        [[CDHelper viewControllerWithView:self].navigationController popViewControllerAnimated:YES];
    }];
}

-(void)setDeviceModel:(TuyaSmartDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    
    self.deviceNameLab.text = deviceModel.name;
    self.idLab.text = deviceModel.devId;
    self.timeLab.text = [CDHelper time_timestampToString:deviceModel.activeTime];
    
    self.ipLab.text = deviceModel.ip;
    
    if (self.deviceModel.ip.length == 0) {
        TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:deviceModel.parentId];
        self.ipLab.text = device.deviceModel.ip;
    }
    
    self.kaiGuanSwitch.on = [deviceModel.dps[@"4"] intValue]?YES:NO;
    self.resetSwitch.on = [deviceModel.dps[@"34"] intValue]?YES:NO;
    self.statusLab.text = deviceModel.dps[@"32"];
    
    
    NSLog(@"----%@",deviceModel.dps);
}

//设备名称
-(void)nameViewClick{
    [CDHelper setupTFAlertWithVC:[CDHelper viewControllerWithView:self] title:@"修改设备名称" placeHolder:@"请输入新的设备名称" sure:^(NSString * _Nonnull tf) {
        [[CDHelper viewControllerWithView:self].view pv_showTextDialog:@"正在修改设备名称..."];
        TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
        [device updateName:tf success:^{
            [[CDHelper viewControllerWithView:self].view pv_successLoading:@"设备名称修改成功!"];
            self.deviceNameLab.text = tf;
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:@"设备名称修改失败!"];
        }];
    }];
}

//共享
-(void)shareViewClick{
    SelectUserShareViewController *userVC = [[SelectUserShareViewController alloc]init];
    [[CDHelper viewControllerWithView:self].navigationController pushViewController:userVC animated:YES];
}

//子设备
-(void)childViewClick{
    ChildListViewController *childVC = [[ChildListViewController alloc]init];
    childVC.deviceModel = self.deviceModel;
    [[CDHelper viewControllerWithView:self].navigationController pushViewController:childVC animated:YES];
}

//删除设备
- (IBAction)sureDelete:(id)sender {
    [CDHelper setupAlterWithVC:[CDHelper viewControllerWithView:self] title:@"确认删除" message:@"确认删除该设备?" sure:^{
        TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
        [device remove:^{
            [[CDHelper viewControllerWithView:self].view pv_successLoading:@"设备删除成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[CDHelper viewControllerWithView:self].navigationController popToRootViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:@"设备删除失败!"];
        }];
    }];
}

@end
