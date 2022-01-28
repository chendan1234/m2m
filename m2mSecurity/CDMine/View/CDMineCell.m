//
//  CDMineCell.m
//  security
//
//  Created by chendan on 2021/6/21.
//

#import "CDMineCell.h"

@interface CDMineCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@end

@implementation CDMineCell

- (void)setModel:(CDMineModel *)model{
    _model = model;
    self.iconImgV.image = [UIImage imageNamed:model.icon];
    self.titleLab.text = model.title;
}

@end
