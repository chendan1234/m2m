//
//  MyHomeListCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import "MyHomeListCell.h"

@interface MyHomeListCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;

@end

@implementation MyHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(TuyaSmartHomeModel *)model{
    _model = model;
    self.nameLab.text = model.name;
    
    NSNumber *homeId = [[NSUserDefaults standardUserDefaults]objectForKey:KHomeId];
    if ([homeId longValue] == model.homeId) {
        self.selectImgV.hidden = NO;
    }else{
        self.selectImgV.hidden = YES;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
