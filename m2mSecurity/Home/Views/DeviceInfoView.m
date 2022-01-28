//
//  DeviceInfoView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "DeviceInfoView.h"
#import "ChildListViewController.h"
#import "SelectUserShareViewController.h"

@interface DeviceInfoView()
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@property (weak, nonatomic) IBOutlet UILabel *ipLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation DeviceInfoView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"DeviceInfoView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.nameView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameViewClick)]];
    [self.shareView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewClick)]];
    [self.childView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(childViewClick)]];
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
    
}

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

-(void)shareViewClick{
    SelectUserShareViewController *userVC = [[SelectUserShareViewController alloc]init];
    [[CDHelper viewControllerWithView:self].navigationController pushViewController:userVC animated:YES];
}

-(void)childViewClick{
    ChildListViewController *childVC = [[ChildListViewController alloc]init];
    childVC.deviceModel = self.deviceModel;
    [[CDHelper viewControllerWithView:self].navigationController pushViewController:childVC animated:YES];
}

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
