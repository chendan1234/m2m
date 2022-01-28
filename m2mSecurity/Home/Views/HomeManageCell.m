//
//  HomeManageCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import "HomeManageCell.h"

@interface HomeManageCell()
@property (weak, nonatomic) IBOutlet UILabel *homeNameLab;

@end

@implementation HomeManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(TuyaSmartHomeModel *)model{
    _model = model;
    self.homeNameLab.text = model.name;
}

@end
