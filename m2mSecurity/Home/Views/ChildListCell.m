//
//  ChildListCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "ChildListCell.h"

@interface ChildListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation ChildListCell

-(void)setModel:(TuyaSmartDeviceModel *)model{
    _model = model;
    self.iconImgV.image = [UIImage imageNamed:[CDHelper getDeviceImageModel:model]];
    self.nameLab.text = model.name;
}

@end
