//
//  ShuXingCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/17.
//

#import "ShuXingCell.h"

@interface ShuXingCell ()
@property (weak, nonatomic) IBOutlet UILabel *shuXingLab;

@end

@implementation ShuXingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setTitle:(NSString *)title{
    _title = title;
    
    self.shuXingLab.text = title;
}


@end
