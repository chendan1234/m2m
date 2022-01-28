//
//  HandleRightCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import "HandleRightCell.h"

@interface HandleRightCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation HandleRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(DeviceModel *)model{
    _model = model;
    
    self.iconV.image = [UIImage imageNamed:model.img];
    self.titleLab.text = model.title;
}

@end
