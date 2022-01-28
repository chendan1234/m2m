//
//  DeviceDetailCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/18.
//

#import "DeviceDetailCell.h"

@interface DeviceDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *valueLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, strong)NSDictionary *dic;

@end

@implementation DeviceDetailCell

-(void)setModel:(DeviceLogListModel *)model{
    _model = model;
    self.nameLab.text = model.name;
    self.valueLab.text = model.value;
    self.timeLab.text = model.timeStr;
}

-(void)setDeviceModel:(TuyaSmartDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    
    self.dic = deviceModel.dps;
    switch ([CDHelper getDeviceCategoryWithModel:deviceModel]) {
        case DeviceCategroyCDYanGan://烟感
            [self yanGan];
            break;
        case DeviceCategroyCDMenChi://门磁
            [self menChi];
            break;
        case DeviceCategroyCDYaoKong://遥控
            [self yaoKong];
            break;
        case DeviceCategroyCDShuiJin://水浸
            [self shuiJin];
            break;
        case DeviceCategroyCDRenTi://人体
            [self renTi];
            break;
        case DeviceCategroyCDShengGuang://声光
            [self shengGuang];
            break;
        case DeviceCategroyCDSOS://sos
            [self sos];
            break;
        default:
            break;
    }
}

//烟感
-(void)yanGan{
    
    if ([self.model.dpId isEqual:@"1"]) {
        if ([self.model.value isEqual:@"alarm"]) {//报警
            [self nonomal];
        }else{
            [self nomal];
        }
    }else if([self.model.dpId isEqual:@"14"]){
        if ([self.model.value isEqual:@"low"]) {//电量低
            [self nonomal];
        }else{
            [self nomal];
        }
    }else{
        [self nomal];
    }
}

//门磁
-(void)menChi{
    if ([self.model.dpId isEqual:@"1"]) {//门磁开门
        if ([self.model.value isEqual:@"true"]) {//报警
            [self nonomal];
        }else{
            [self nomal];
        }
    }else if([self.model.dpId isEqual:@"2"]){
        [self setDianLiang];
    }else{
        [self nomal];
    }
}

//遥控
-(void)yaoKong{
    if ([self.model.dpId isEqual:@"3"]) {
        [self setDianLiang];
    }else if([self.model.dpId isEqual:@"26"]){
        if ([self.model.value isEqual:@"disarmed"]) {
            [self nonomal];
        }else{
            [self nomal];
        }
    }else if([self.model.dpId isEqual:@"27"]){
        if ([self.model.value isEqual:@"arm"]) {
            [self nonomal];
        }else{
            [self nomal];
        }
    }else if([self.model.dpId isEqual:@"28"]){
        if ([self.model.value isEqual:@"home"]) {
            [self nonomal];
        }else{
            [self nomal];
        }
    }else if([self.model.dpId isEqual:@"29"]){
        if ([self.model.value isEqual:@"sos"]) {
            [self nonomal];
        }else{
            [self nomal];
        }
    }else{
        [self nomal];
    }
}

//声光
-(void)shengGuang{
    if ([self.model.dpId isEqual:@"13"]) {
        if ([self.model.value isEqual:@"true"]) {
            [self nonomal];
        }else{
            [self nomal];
        }
    }else if([self.model.dpId isEqual:@"14"]){
        if ([self.model.value intValue] <= 20) {
            [self nonomal];
        }else{
            [self nomal];
        }
    }else{
        [self nomal];
    }
}

//水侵
-(void)shuiJin{
    if ([self.model.dpId isEqual:@"1"]) {
        if ([self.model.value isEqual:@"alarm"]) {
            [self nonomal];
        }else{
            [self nomal];
        }
    }else if([self.model.dpId isEqual:@"4"]){
        [self setDianLiang];
    }else{
        [self nomal];
    }
}

//人体
-(void)renTi{
    if ([self.model.dpId isEqual:@"1"]) {
        if ([self.model.value isEqual:@"pir"]) {
            [self nonomal];
        }else{
            [self nomal];
        }
    }else if([self.model.dpId isEqual:@"4"]){
        [self setDianLiang];
    }else{
        [self nomal];
    }
}

//紧急按钮
-(void)sos{
    if ([self.model.dpId isEqual:@"29"]) {
        if ([self.model.value isEqual:@"sos"]) {
            [self nonomal];
        }else{
            [self nomal];
        }
    }else if([self.model.dpId isEqual:@"3"]){
        [self setDianLiang];
    }else{
        [self nomal];
    }
}

#pragma ------------电量,图片-----------

//设置数值型的电量
-(void)setDianLiang{
    if ([self.model.value intValue] <= 10) {//电量低
        [self nonomal];
    }else{
        [self nomal];
    }
}

//不正常 警告
-(void)nonomal{
    self.imageView.image = [UIImage imageNamed:@"nonomal"];
}

//正常 信息类
-(void)nomal{
    self.imageView.image = [UIImage imageNamed:@"xinxi"];
}


@end
