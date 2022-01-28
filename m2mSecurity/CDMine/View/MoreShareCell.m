//
//  MoreShareCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "MoreShareCell.h"


@interface MoreShareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;

@end

@implementation MoreShareCell

-(void)setModel:(MoreShareDeviceModel *)model{
    _model = model;
    
    self.iconImgV.image = [UIImage imageNamed:[CDHelper getDeviceImageModel:model.model]];
    self.nameLab.text = model.model.name;
    self.selectImgV.image = model.isSelected?[UIImage imageNamed:@"xuan"]:[UIImage imageNamed:@"yq"];
}

@end
