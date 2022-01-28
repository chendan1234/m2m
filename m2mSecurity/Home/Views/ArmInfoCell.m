//
//  ArmInfoCell.m
//  m2mSecurity
//
//  Created by chendan on 2022/1/19.
//

#import "ArmInfoCell.h"

@interface ArmInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *devLab;

@end

@implementation ArmInfoCell

-(void)setModel:(ArmInfoModel *)model{
    _model = model;
    
    self.desLab.text = model.des;
    self.timeLab.text = [CDHelper time_timestampToString:[model.createTime integerValue]/1000];
    
    TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:model.devId];
    self.devLab.text = device.deviceModel.name.length?device.deviceModel.name:@"紧急报警";
}

@end
