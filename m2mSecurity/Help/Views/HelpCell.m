//
//  HelpCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/10.
//

#import "HelpCell.h"

@interface HelpCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation HelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HelpModel *)model{
    _model = model;
    self.titleLab.text = model.title;
}

@end
