//
//  MyShareCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "MyShareCell.h"

@interface MyShareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation MyShareCell

-(void)setModel:(TuyaSmartShareDeviceModel *)model{
    _model = model;
    
    TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:model.devId];
    self.iconImgV.image = [UIImage imageNamed:[CDHelper getDeviceImageModel:device.deviceModel]];
    self.nameLab.text = model.name;
}

- (IBAction)cancelShare:(id)sender {
    
    [CDHelper setupAlterWithVC:[CDHelper viewControllerWithView:self] title:@"确认取消共享?" message:[NSString stringWithFormat:@"确认取消共享%@",self.model.name] sure:^{
        if (self.reloadBlock) {
            self.reloadBlock();
        }
    }];
}

@end
