//
//  MenLingPhotoView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/24.
//

#import "MenLingPhotoView.h"
#import <TYEncryptImage/TYEncryptImage.h>

@interface MenLingPhotoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation MenLingPhotoView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MenLingPhotoView" owner:nil options:nil]lastObject];
}

-(void)setMessageModel:(TuyaSmartCameraMessageModel *)messageModel{
    _messageModel = messageModel;
    
    NSArray *components = [messageModel.attachPic componentsSeparatedByString:@"@"];
    if (components.count != 2) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:messageModel.attachPic] placeholderImage:[UIImage imageNamed:@""]];
    }else {
        [self.imageV ty_setAESImageWithPath:components.firstObject encryptKey:components.lastObject placeholderImage:[UIImage imageNamed:@""]];
    }
}

@end
