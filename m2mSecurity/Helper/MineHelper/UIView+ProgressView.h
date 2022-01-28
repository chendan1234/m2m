//
//  UIView+ProgressView.h
//  YouJia
//
//  Created by gaofu on 15/9/29.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ProgressView)

/**
 *  @author gaofu, 15-09-29 16:09:34
 *
 *  正在加载
 */
-(void)pv_showTextDialog:(NSString*)log;


/**
 *  @author gaofu, 15-09-29 17:09:57
 *
 *  加载成功
 *
 *  @param log 提示文字
 */
-(void)pv_successLoading:(NSString*)log;

/**
 *  @author gaofu, 15-09-29 17:09:21
 *
 *  加载失败
 *
 *  @param log 提示文字
 */
-(void)pv_failureLoading:(NSString*)log;

/**
 *  @author gaofu, 15-09-29 17:09:34
 *
 *  文字提示框
 *
 *  @param log 提示文字
 */
-(void)pv_warming:(NSString*)log;


/**
 *  @author gaofu, 15-09-29 16:09:03
 *
 *  提示框消失
 */
-(void)pv_hideMBHub;


@end
