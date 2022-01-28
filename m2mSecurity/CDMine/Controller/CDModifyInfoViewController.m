//
//  CDModifyInfoViewController.m
//  security
//
//  Created by chendan on 2021/5/31.
//

#import "CDModifyInfoViewController.h"
#import "UIView+ProgressView.h"
#import "HttpRequest.h"
#import "CDCommonDefine.h"
#import "CDHelper.h"

#import <UIImageView+WebCache.h>

@interface CDModifyInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *nickNameV;
@property (weak, nonatomic) IBOutlet UIView *addressV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIView *sexV;
@property (weak, nonatomic) IBOutlet UIView *iconV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@property (nonatomic, strong)UIButton *selectedBtn;
@property (nonatomic, strong)NSString *uploadUrl;

@end

@implementation CDModifyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = KChangeUserInoTitle;
    
    //初始化
    [self setup];
}



//初始化
-(void)setup{
    
    CDAppUser *user = [CDAppUser getUser];
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"user"]];
    self.addressLab.text = user.address;
    self.nickNameLab.text = user.username;
    self.uploadUrl = user.avatarUrl;
    
    [self.nickNameV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nickNameVClick)]];
    [self.addressV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressVClick)]];
    [self.iconV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconVClick)]];
    
    //设置性别点击事件
    for (NSInteger i = 0; i < self.sexV.subviews.count; i++) {
        UIButton *sexBtn = (UIButton *)self.sexV.subviews[i];
        [sexBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sexBtn setImage:[UIImage imageNamed:@"agree_selected"] forState:UIControlStateDisabled];
        if ([user.sex intValue] == i+1) {
            [self sexBtnClick:sexBtn];
        }
    }
}

//设置性别点击事件
-(void)sexBtnClick:(UIButton *)sender{
    sender.enabled = NO;
    self.selectedBtn.enabled = YES;
    self.selectedBtn = sender;
}

//点击昵称
-(void)nickNameVClick{
    [self setupAlertWithTitle:@"昵称" lab:self.nickNameLab];
}

//点击家庭住址
-(void)addressVClick{
    [self setupAlertWithTitle:@"家庭住址" lab:self.addressLab];
}

//弹框
-(void)setupAlertWithTitle:(NSString *)title lab:(UILabel *)lab{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改%@",title] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [NSString stringWithFormat:@"请输入%@",title];
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *field = alertController.textFields.firstObject;
        
        if (field.text.length) {
            lab.text = field.text;
        }else{
            [self.view pv_warming:@"输入内容不能为空!"];
        }
    }]];
        
        
        
    //present出AlertView
    [self presentViewController:alertController animated:YES completion:nil];
}

//上传头像
-(void)iconVClick{
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    /*
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     */
    UIImage *headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getImageUrlWithImage:headImage];
    });
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getImageUrlWithImage:(UIImage *)image
{
    [self.view pv_showTextDialog:@"正在上传..."];
    [HttpRequest HR_ImageUpdateWithContent:UIImageJPEGRepresentation(image,0.4) success:^(id result) {
        
        if ([result[@"code"] intValue] == 200){
            [self.view pv_hideMBHub];
            self.iconImgV.image = image;
            self.uploadUrl = result[@"data"];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }

    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
}

//保存
- (IBAction)saveBtnClick:(id)sender {
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"avatarUrl"] = self.uploadUrl;
    parames[@"address"] = self.addressLab.text;
    parames[@"username"] = self.nickNameLab.text;
    parames[@"sex"] = [self.selectedBtn.titleLabel.text isEqual:@"Man"]?@"1":@"2";
    parames[@"userId"] = [[NSUserDefaults standardUserDefaults]objectForKey:KUserId];
    
    [self.view pv_showTextDialog:@"正在修改资料..."];
    
    [HttpRequest HR_ModifyPersonalDataWithParams:parames success:^(id result) {
        
        if ([result[@"code"] intValue] == 200) {
            [self.view pv_successLoading:@"修改成功!"];
            [self saveSuccess];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
        
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
}

-(void)saveSuccess{
    
    CDAppUser *user = [CDAppUser getUser];
    
    user.address = self.addressLab.text;
    user.avatarUrl = self.uploadUrl;
    user.username = self.nickNameLab.text;
    user.sex = [self.selectedBtn.titleLabel.text isEqual:@"Man"]?@"1":@"2";
    user.userId = [[NSUserDefaults standardUserDefaults]objectForKey:KUserId];
    
    [CDAppUser setUser:user];
    
    
    [self saveInfoToTuya];//涂鸦更新名称和头像
    
    if (self.myBlock) {
        self.myBlock();
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:KChangeUserIcon object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)saveInfoToTuya{
    [[TuyaSmartUser sharedInstance] updateNickname:self.nickNameLab.text success:^{
        NSLog(@"用户名更新成功");
    } failure:^(NSError *error) {
        NSLog(@"用户名更新失败");
    }];
    
    [[TuyaSmartUser sharedInstance] updateHeadIcon:[CDHelper getImageFromURL:self.uploadUrl] success:^{
        NSLog(@"头像更新成功");
    } failure:^(NSError *error) {
         NSLog(@"头像更新失败");
    }];
}



@end
