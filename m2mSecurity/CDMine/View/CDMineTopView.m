//
//  CDMineTopView.m
//  security
//
//  Created by chendan on 2021/6/21.
//

#import "CDMineTopView.h"

@interface CDMineTopView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UILabel *expireLab;

@end

@implementation CDMineTopView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"CDMineTopView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:KUpdateExpireTime object:nil];
    
    
}

-(void)setUpInfo{
    CDAppUser *user = [CDAppUser getUser];
    
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"user"]];
    self.nameLab.text = user.username;
    self.accountLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:KLoginAccount];
    
    if (user.expireTime) {
        self.expireLab.text = [NSString stringWithFormat:@"到期时间: %@",[CDHelper time_timestampToString2:user.expireTime/1000]];
    }else{
        self.expireLab.text = @"暂无订阅";
    }
}

-(void)getUserInfo{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserId];
    [HttpRequest HR_AppUserInfoWithContent:userId Params:@{} success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            NSInteger time = [result[@"data"][@"expireTime"] longValue];
            self.expireLab.text = [NSString stringWithFormat:@"到期时间: %@",[CDHelper time_timestampToString2:time/1000]];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
