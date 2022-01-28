//
//  DeviceShengGuangView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/16.
//

#import "DeviceShengGuangView.h"
#import "SelectUserShareViewController.h"
#import "LSTPopView.h"
#import "ShuXingView.h"

@interface DeviceShengGuangView ()

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@property (weak, nonatomic) IBOutlet UILabel *ipLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *kaiguanView;//报警开关
@property (weak, nonatomic) IBOutlet UIView *yingLiangView;//报警音量
@property (weak, nonatomic) IBOutlet UIView *liangDuView;//亮度调节
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;//报警时长
@property (weak, nonatomic) IBOutlet UILabel *kaiGuanLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLongLab;
@property (weak, nonatomic) IBOutlet UILabel *yinLiangLab;
@property (weak, nonatomic) IBOutlet UILabel *liangDuLab;

@property (nonatomic, strong)TuyaSmartDevice *device;

@end

#define TowLineH 245
#define ThreeLineH 290
#define FourLineH 345

@implementation DeviceShengGuangView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"DeviceShengGuangView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.nameView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameViewClick)]];
    [self.shareView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewClick)]];
    
    [self.kaiguanView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kaiguanViewClick)]];
    [self.yingLiangView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yingLiangViewClick)]];
    [self.liangDuView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liangDuViewClick)]];
    
    self.timeSlider.maximumValue = 3600;
    self.timeSlider.minimumValue = 0;
    [self.timeSlider addTarget:self action:@selector(valueChanged:forEvent:) forControlEvents:(UIControlEventValueChanged)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    });
    
}

#pragma mark -----弹框-----
//报警开关
-(void)kaiguanViewClick{
    NSArray *dataArr = @[@"声光报警中",@"声光报警解除"];
    NSString *title = @"报警开关";
    [CDHelper setupShuXingTanKuangWith:dataArr viewH:TowLineH title:title selectBlock:^(NSString * _Nonnull selectValue) {
        NSDictionary *dps = @{@"13": [selectValue isEqualToString:@"声光报警中"]?@(YES):@(NO)}; //开关
        [self.device publishDps:dps success:^{
            self.kaiGuanLab.text = selectValue;
        } failure:^(NSError *error) {
            [self failChangeShuXingWithTitle:title];
        }];
    }];
}

//报警音量
-(void)yingLiangViewClick{
    NSArray *dataArr = @[@"mute",@"low",@"middle",@"high"];
    NSString *title = @"报警音量";
    [CDHelper setupShuXingTanKuangWith:dataArr viewH:FourLineH title:title selectBlock:^(NSString * _Nonnull selectValue) {
        NSDictionary *dps = @{ @"5" : selectValue }; //音量
        [self.device publishDps:dps success:^{
            self.yinLiangLab.text = selectValue;
        } failure:^(NSError *error) {
            [self failChangeShuXingWithTitle:title];
        }];
    }];
}

//亮度调节
-(void)liangDuViewClick{
    NSArray *dataArr = @[@"dark",@"weak",@"middle",@"strong"];
    NSString *title = @"亮度调节";
    [CDHelper setupShuXingTanKuangWith:dataArr viewH:FourLineH title:title selectBlock:^(NSString * _Nonnull selectValue) {
        NSDictionary *dps = @{ @"17" : selectValue }; //亮度
        [self.device publishDps:dps success:^{
            self.liangDuLab.text = selectValue;
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


//赋值
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
    
    //报警开关
    if ([deviceModel.dps[@"13"] intValue] == 0) {
        self.kaiGuanLab.text = @"声光报警解除";
    }else{
        self.kaiGuanLab.text = @"声光报警中";
    }
    
    //报警音量
    self.yinLiangLab.text = deviceModel.dps[@"5"];
    
    //光亮调节
    self.liangDuLab.text = deviceModel.dps[@"17"];
    
    //报警时长
    self.timeSlider.value = [deviceModel.dps[@"18"] intValue];
    
    self.timeLongLab.text = [CDHelper getMMSSFromSS:self.timeSlider.value];
}

//报警时长
-(void)valueChanged:(UISlider *)slider forEvent:(UIEvent*)event{
    
    UITouch *touchEvent = [[event allTouches] anyObject];
    switch (touchEvent.phase) {
        case UITouchPhaseEnded:
        {
            NSInteger time = [[NSString stringWithFormat:@"%f",slider.value] intValue];
            NSDictionary *dps = @{ @"18" : @(time) }; //亮度
            [self.device publishDps:dps success:^{
                self.timeLongLab.text = [CDHelper getMMSSFromSS:time];
            } failure:^(NSError *error) {
                [self failChangeShuXingWithTitle:@"报警时长"];
            }];
            
        }
            break;
            
        default:
            break;
    }
    
    
}

//修改名字
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


//确定删除
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
