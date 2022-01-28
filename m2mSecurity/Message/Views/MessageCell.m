//
//  MessageCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/9.
//

#import "MessageCell.h"
#import "MessageDetailViewController.h"

@interface MessageCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipW;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end


@implementation MessageCell

-(void)setModel:(MessageModel *)model{
    _model = model;
    
    self.titleLab.text = model.title;
    self.timeLab.text = [CDHelper time_timestampToString:model.createTime / 1000];
//    self.contentLab.text = model.body;
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:model.body];
       NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
       [paragraphStyle setLineSpacing:6];
    paragraphStyle.alignment = NSTextAlignmentJustified;
       
       [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.body length])];
       
       [self.contentLab setAttributedText:attributedString];
    self.contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    if (self.model.isRead) {
        self.tipW.constant = 0;
    }else{
        self.tipW.constant = 16;
    }
}


@end
