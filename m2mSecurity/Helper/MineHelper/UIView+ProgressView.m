//
//  UIView+ProgressView.m
//  YouJia
//
//  Created by gaofu on 15/9/29.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#import "UIView+ProgressView.h"
#import "MBProgressHUD.h"

const static NSTimeInterval showTime = 1.0f;//显示时间

static NSString *const successImage = @"chenggong";//成功图片
static NSString *const errorImage = @"cuowu";//失败图片
static NSString *const progressImage = @"jiazai";//加载图片
static NSString *const warmImage = @"jinggao";//警告

@implementation UIView (ProgressView)

#pragma mark---------------加载中...---------------
-(void)pv_showTextDialog:(NSString*)log
{
    [self pv_hideMBHub];
    //初始化进度框，置于当前的View当中
    MBProgressHUD * HUD = [MBProgressHUD new];
    [self addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.userInteractionEnabled = NO;
    //设置对话框文字
    if (log.length)
    {
        HUD.label.text= log;
    }
    else
    {
        HUD.label.text = @"加载中...";
    }
    
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:progressImage]];
    
    //图片旋转效果
    CABasicAnimation * rotate = [CABasicAnimation animation];
    rotate.keyPath = @"transform.rotation";
    rotate.toValue=@(M_PI);
    rotate.cumulative = YES;
    rotate.duration = showTime;
    rotate.repeatCount =HUGE_VALF;
    [HUD.customView.layer addAnimation:rotate forKey:nil];
    
    [HUD showAnimated:YES];
    HUD.removeFromSuperViewOnHide = YES;
}

#pragma mark---------------加载成功---------------
-(void)pv_successLoading:(NSString*)log
{
    [self pv_hideMBHub];
    MBProgressHUD * HUD = [MBProgressHUD new];
    [self addSubview:HUD];
    HUD.userInteractionEnabled = NO;
    HUD.mode = MBProgressHUDModeCustomView;
    if (log.length)
    {
        HUD.label.text = log;
    }
    else
    {
        HUD.label.text = @"成功!";
    }
    HUD.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:successImage]];
    
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:showTime];
    HUD.removeFromSuperViewOnHide = YES;
}

#pragma mark---------------加载失败---------------
-(void)pv_failureLoading:(NSString*)log
{
    [self pv_hideMBHub];
    MBProgressHUD * HUD = [MBProgressHUD new];
    [self addSubview:HUD];
    HUD.userInteractionEnabled = NO;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.label.numberOfLines = 0;
    //设置对话框的文字
    if (log.length)
    {
        HUD.label.text = log;
    }
    else
    {
        HUD.label.text = @"失败!";
    }
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:errorImage]];
    
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:showTime];
    HUD.removeFromSuperViewOnHide = YES;
}

#pragma mark---------------文字框---------------
-(void)pv_warming:(NSString*)log
{
    [self pv_hideMBHub];
    MBProgressHUD * HUD = [MBProgressHUD new];
    [self addSubview:HUD];
    HUD.userInteractionEnabled = NO;
    HUD.label.numberOfLines = 0;
    //设置对话框的文字
    if (log.length)
    {
        HUD.detailsLabel.text = log;
        HUD.detailsLabel.font = [UIFont systemFontOfSize:16];
    }
    else
    {
        HUD.label.text = @"提示!";
    }
    HUD.mode=MBProgressHUDModeCustomView;
    
    
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:warmImage]];
    
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:2*showTime];
    HUD.removeFromSuperViewOnHide = YES;
}

#pragma mark---------------提示框消失---------------
-(void)pv_hideMBHub
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}


@end
