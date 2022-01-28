//
//  CDQuickCell.m
//  Security
//
//  Created by chendan on 2021/7/6.
//

#import "CDQuickCell.h"

@interface CDQuickCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@end

@implementation CDQuickCell

- (void)setModel:(TuyaSmartDeviceModel *)model{
    _model = model;
    self.nameLab.text = model.name;
    self.iconImgV.image = [UIImage imageNamed:[CDHelper getDeviceImageModel:model]];
}



@end
