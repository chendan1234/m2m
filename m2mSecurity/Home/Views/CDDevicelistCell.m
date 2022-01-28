//
//  CDDevicelistCell.m
//  Security
//
//  Created by chendan on 2021/7/7.
//

#import "CDDevicelistCell.h"

@interface CDDevicelistCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *dianLab;
@property (weak, nonatomic) IBOutlet UILabel *shareLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation CDDevicelistCell

-(void)setModel:(TuyaSmartDeviceModel *)model{
    _model = model;
    self.nameLab.text = model.name;
    self.iconV.image = [UIImage imageNamed:[CDHelper getDeviceImageModel:model]];
    self.statusLab.text = model.isOnline?@"在线":@"离线";
    
//    NSLog(@"---name = %@, devId = %@, productId = %@",model.name,model.devId,model.productId);
    
    if (model.isShare) {
        self.shareLab.hidden = NO;
        self.lineView.hidden = NO;
    }else{
        self.shareLab.hidden = YES;
        self.lineView.hidden = YES;
    }
}



@end
