//
//  MyShareUserCell.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/7.
//

#import "MyShareUserCell.h"

@interface MyShareUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation MyShareUserCell

-(void)setUserModel:(TuyaSmartShareMemberModel *)userModel{
    _userModel = userModel;
    
    self.nameLab.text = userModel.nickName;
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:userModel.iconUrl] placeholderImage:[UIImage imageNamed:@"user"]];
    
    NSLog(@"----%@",userModel.iconUrl);
    
}

-(void)setType:(NSInteger)type{
    _type = type;
}

//全部取消
- (IBAction)allCancel:(id)sender {
    
    [CDHelper setupAlterWithVC:[CDHelper viewControllerWithView:self] title:@"确定取消该用户全部共享设备?" message:@"全部取消将删除该共享者, 您与之的共享设备将全部移除!" sure:^{
        [self deleteUser];
    }];
    
//    [CDHelper setupTFAlertWithVC:[CDHelper viewControllerWithView:self] title:@"修改昵称" placeHolder:@"请输入共享者昵称" sure:^(NSString * _Nonnull tf) {
//        [self updateNameWith:tf];
//    }];
    
    
}

-(void)updateNameWith:(NSString *)name{
    TuyaSmartHomeDeviceShare *deviceShare = [[TuyaSmartHomeDeviceShare alloc]init];
    [[CDHelper viewControllerWithView:self].view pv_showTextDialog:@"正在修改..."];
    if (self.type == 2) {//我分享给别人, 删除收到共享者
        [deviceShare renameShareMemberNameWithMemberId:self.userModel.memberId name:name success:^{
            [self deleteSuccess];
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:@"昵称修改失败!"];
        }];
    }else{//别人分享给我, 删除主动共享者
        [deviceShare renameReceiveShareMemberNameWithMemberId:self.userModel.memberId name:name success:^{
            [self deleteSuccess];
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:@"昵称修改失败!"];
        }];
    }
}

-(void)deleteUser{
    TuyaSmartHomeDeviceShare *deviceShare = [[TuyaSmartHomeDeviceShare alloc]init];
    [[CDHelper viewControllerWithView:self].view pv_showTextDialog:@"正在删除..."];
    if (self.type == 2) {//我分享给别人, 删除收到共享者
        [deviceShare removeShareMemberWithMemberId:self.userModel.memberId success:^{
            [self deleteSuccess];
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:@"共享者删除失败!"];
        }];
    }else{//别人分享给我, 删除主动共享者
        [deviceShare removeReceiveShareMemberWithMemberId:self.userModel.memberId success:^{
            [self deleteSuccess];
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:@"共享者删除失败!"];
        }];
    }
}

-(void)deleteSuccess{
    [[CDHelper viewControllerWithView:self].view pv_successLoading:@"已删除!"];
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}


@end
