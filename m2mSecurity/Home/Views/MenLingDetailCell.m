//
//  MenLingDetailCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/24.
//

#import "MenLingDetailCell.h"
#import <TYEncryptImage/TYEncryptImage.h>

@interface MenLingDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation MenLingDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setMessageModel:(TuyaSmartCameraMessageModel *)messageModel{
    _messageModel = messageModel;
    NSArray *components = [messageModel.attachPic componentsSeparatedByString:@"@"];
    if (components.count != 2) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:messageModel.attachPic] placeholderImage:[UIImage imageNamed:@""]];
    }else {
        [self.imgV ty_setAESImageWithPath:components.firstObject encryptKey:components.lastObject placeholderImage:[UIImage imageNamed:@""]];
    }
    self.titleLab.text = messageModel.msgTitle;
    self.subTitleLab.text = messageModel.msgContent;
    self.timeLab.text = messageModel.dateTime;
}

@end
