//
//  HandleLeftCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import "HandleLeftCell.h"

@interface HandleLeftCell()

@property (weak, nonatomic) IBOutlet UIView *tipV;

@end

@implementation HandleLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    self.tipV.hidden = !selected;
    self.titleLab.textColor = selected?KColorA(0, 117, 227, 1):KColorA(70, 70, 70, 1);
}

@end
