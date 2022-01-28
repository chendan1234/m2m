//
//  CDDeviceListCollectionCell.m
//  Security
//
//  Created by chendan on 2021/7/7.
//

#import "CDDeviceListCollectionCell.h"

@interface CDDeviceListCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *shareLab;


@end

@implementation CDDeviceListCollectionCell

-(void)setModel:(TuyaSmartDeviceModel *)model{
    _model = model;
    self.nameLab.text = model.name;
    self.iconV.image = [UIImage imageNamed:[CDHelper getDeviceImageModel:model]];
    self.statusLab.text = model.isOnline?@"在线":@"离线";

    if (model.isShare) {
        self.shareLab.hidden = NO;
    }else{
        self.shareLab.hidden = YES;
    }
}

@end
