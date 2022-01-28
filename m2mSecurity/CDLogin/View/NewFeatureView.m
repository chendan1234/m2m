//
//  NewFeatureView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/28.
//

#import "NewFeatureView.h"

@interface NewFeatureView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;

@end

@implementation NewFeatureView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NewFeatureView" owner:nil options:nil]lastObject];
}

-(void)setModel:(NewFeatureModel *)model{
    _model = model;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
}




@end
