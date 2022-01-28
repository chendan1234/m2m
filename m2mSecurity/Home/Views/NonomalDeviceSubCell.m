//
//  NonomalDeviceSubCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/12/28.
//

#import "NonomalDeviceSubCell.h"

@interface NonomalDeviceSubCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end

@implementation NonomalDeviceSubCell

-(void)setDevId:(NSString *)devId{
    _devId = devId;
    
    TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:devId];
    self.nameLab.text = device.deviceModel.name;

}

@end
