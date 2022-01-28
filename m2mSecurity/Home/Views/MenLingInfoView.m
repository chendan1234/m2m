//
//  MenLingInfoView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/28.
//

#import "MenLingInfoView.h"
#import "SelectUserShareViewController.h"
#import "LSTPopView.h"
#import "ShuXingView.h"

@interface MenLingInfoView()

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@property (weak, nonatomic) IBOutlet UILabel *ipLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;


@property (weak, nonatomic) IBOutlet UILabel *dianLiangLab;//电池电量
@property (weak, nonatomic) IBOutlet UILabel *gongDianStyleLab;//供电模式
@property (weak, nonatomic) IBOutlet UILabel *cunNumLab;//存储卡容量
@property (weak, nonatomic) IBOutlet UILabel *cunStatusLab;//存储卡状态



@property (weak, nonatomic) IBOutlet UIView *pirView;//PIR开关
@property (weak, nonatomic) IBOutlet UIView *workView;//工作模式
@property (weak, nonatomic) IBOutlet UISlider *baoJingSlider;//低电量报警
@property (weak, nonatomic) IBOutlet UILabel *dianNumLab;//低电量报警lab
@property (weak, nonatomic) IBOutlet UILabel *pirLab;//PIR开关lab
@property (weak, nonatomic) IBOutlet UILabel *workLab;//工作模式

@property (weak, nonatomic) IBOutlet UISwitch *fanSwitch;//页面反正
@property (weak, nonatomic) IBOutlet UISwitch *timeSwitch;//时间水印
@property (weak, nonatomic) IBOutlet UISwitch *deviceStatusSwitch;//设备状态
@property (weak, nonatomic) IBOutlet UISwitch *cunSwitch;//存储卡格式化

@property (nonatomic, strong)TuyaSmartDevice *device;

@end

#define TowLineH 245
#define ThreeLineH 290
#define FourLineH 345

@implementation MenLingInfoView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MenLingInfoView" owner:nil options:nil]lastObject];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.nameView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameViewClick)]];
    [self.shareView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewClick)]];
    
    [self.pirView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pirViewClick)]];
    [self.workView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(workViewClick)]];
    
    self.baoJingSlider.maximumValue = 30;
    self.baoJingSlider.minimumValue = 10;
    [self.baoJingSlider addTarget:self action:@selector(valueChanged:forEvent:) forControlEvents:(UIControlEventValueChanged)];
    
    
    [self.fanSwitch addTarget:self action:@selector(fanSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.timeSwitch addTarget:self action:@selector(timeSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deviceStatusSwitch addTarget:self action:@selector(deviceStatusSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cunSwitch addTarget:self action:@selector(cunSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    });
    
}

#pragma mark -----Switch-----
//页面反正
-(void)fanSwitchClick:(UISwitch *)sender{
    NSDictionary *dps = @{@"103": @(sender.on)}; //开关
    [self.device publishDps:dps success:^{
        [[CDHelper viewControllerWithView:self].view pv_successLoading:@"修改成功!"];
    } failure:^(NSError *error) {
        [self failChangeShuXingWithTitle:@"报警开关"];
    }];
}

//时间水印
-(void)timeSwitchClick:(UISwitch *)sender{
    NSDictionary *dps = @{@"104": @(sender.on)}; //开关
    [self.device publishDps:dps success:^{
        [[CDHelper viewControllerWithView:self].view pv_successLoading:@"修改成功!"];
    } failure:^(NSError *error) {
        [self failChangeShuXingWithTitle:@"报警开关"];
    }];
}

//设备状态
-(void)deviceStatusSwitchClick:(UISwitch *)sender{
    NSDictionary *dps = @{@"149": @(sender.on)}; //开关
    [self.device publishDps:dps success:^{
        [[CDHelper viewControllerWithView:self].view pv_successLoading:@"修改成功!"];
    } failure:^(NSError *error) {
        [self failChangeShuXingWithTitle:@"报警开关"];
    }];
}

//存储卡格式化
-(void)cunSwitchClick:(UISwitch *)sender{
    NSDictionary *dps = @{@"111": @(sender.on)}; //开关
    [self.device publishDps:dps success:^{
        [[CDHelper viewControllerWithView:self].view pv_successLoading:@"修改成功!"];
    } failure:^(NSError *error) {
        [self failChangeShuXingWithTitle:@"报警开关"];
    }];
}


#pragma mark -----弹框-----
//pir
-(void)pirViewClick{
    NSArray *dataArr = @[@"关闭",@"灵敏度低",@"灵敏度中",@"灵敏度高"];
    NSString *title = @"PIR开关及灵敏度";
    [CDHelper setupShuXingTanKuangWith:dataArr viewH:FourLineH title:title selectBlock:^(NSString * _Nonnull selectValue) {
        
        NSInteger index = 0;
        for (NSInteger i = 0; i < dataArr.count; i++) {
            if ([selectValue isEqualToString:dataArr[i]]) {
                index = i;
                break;
            }
        }
        
        NSDictionary *dps = @{@"152": [NSString stringWithFormat:@"%ld",index]};//pir
        [self.device publishDps:dps success:^{
            self.pirLab.text = selectValue;
        } failure:^(NSError *error) {
            [self failChangeShuXingWithTitle:title];
        }];
    }];
}

//工作模式
-(void)workViewClick{
    NSArray *dataArr = @[@"低功耗模式",@"连续工作模式"];
    NSString *title = @"工作模式";
    [CDHelper setupShuXingTanKuangWith:dataArr viewH:TowLineH title:title selectBlock:^(NSString * _Nonnull selectValue) {
        
        NSInteger index = 0;
        if ([selectValue isEqualToString:@"连续工作模式"]) {
            index = 1;
        }
        
        NSDictionary *dps = @{ @"189" : [NSString stringWithFormat:@"%ld",index]}; //音量
        [self.device publishDps:dps success:^{
            self.workLab.text = selectValue;
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

#pragma mark -----赋值-----
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
    
    //电池电量
    self.dianLiangLab.text = [NSString stringWithFormat:@"%@",deviceModel.dps[@"145"]];
    
    //供电模式
    self.gongDianStyleLab.text = @"电池供电";
    if ([deviceModel.dps[@"146"] intValue] == 1) {
        self.gongDianStyleLab.text = @"插电供电";
    }
    
    //存储卡容量
    self.cunNumLab.text = [NSString stringWithFormat:@"%@ KB",deviceModel.dps[@"109"]];
    
    //存储卡状态
    self.cunStatusLab.text = @"正常";//1

    NSInteger cunStatus = [deviceModel.dps[@"110"] intValue];
    if (cunStatus == 2) {
        self.cunStatusLab.text = @"异常";
    }else if (cunStatus == 3){
        self.cunStatusLab.text = @"空间不足";
    }else if (cunStatus == 4){
        self.cunStatusLab.text = @"正在格式化";
    }else if (cunStatus == 5){//5
        self.cunStatusLab.text = @"无SD卡";
    }
    
    //低电量报警
    self.baoJingSlider.value = [deviceModel.dps[@"147"] intValue];
    self.dianNumLab.text = [NSString stringWithFormat:@"%@",deviceModel.dps[@"147"]];
    
    //pir
    NSInteger pir = [deviceModel.dps[@"152"] intValue];
    if (pir == 0) {
        self.pirLab.text = @"关闭";
    }else if (pir == 1){
        self.pirLab.text = @"灵敏度低";
    }else if (pir == 2){
        self.pirLab.text = @"灵敏度中";
    }else if (pir == 3){
        self.pirLab.text = @"灵敏度高";
    }
    
    //工作模式
    NSInteger work = [deviceModel.dps[@"189"] intValue];
    if (work == 0) {
        self.workLab.text = @"低功耗模式";
    }else if (work == 1){
        self.workLab.text = @"连续工作模式";
    }
    
    //switch
    self.fanSwitch.on = [deviceModel.dps[@"103"] intValue]?YES:NO;//页面翻转
    self.timeSwitch.on = [deviceModel.dps[@"104"] intValue]?YES:NO;//时间水印
    self.deviceStatusSwitch.on = [deviceModel.dps[@"149"] intValue]?YES:NO;//设备状态
    self.cunSwitch.on = [deviceModel.dps[@"111"] intValue]?YES:NO;//存储卡格式化
    
}

//低电量报警
-(void)valueChanged:(UISlider *)slider forEvent:(UIEvent*)event{
    
    UITouch *touchEvent = [[event allTouches] anyObject];
    switch (touchEvent.phase) {
        case UITouchPhaseEnded:
        {
            NSInteger num = [[NSString stringWithFormat:@"%f",slider.value] intValue];
            NSDictionary *dps = @{ @"147" : @(num) }; //亮度
            [self.device publishDps:dps success:^{
                self.dianNumLab.text = [NSString stringWithFormat:@"%ld",num];
            } failure:^(NSError *error) {
                [self failChangeShuXingWithTitle:@"低电量报警"];
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
