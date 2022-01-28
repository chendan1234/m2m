//
//  UIView+DSExtension.h
//  dashujinfu
//
//  Created by apple on 2017/3/2.
//  Copyright © 2017年 华博金创. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DSExtension)

@property(nonatomic,assign)CGSize size;

@property(nonatomic,assign)CGFloat width;

@property(nonatomic,assign)CGFloat height;

@property(nonatomic,assign)CGFloat x;

@property(nonatomic,assign)CGFloat y;

@property(nonatomic,assign)CGFloat centerX;

@property(nonatomic,assign)CGFloat centerY; 

//在分类中声明@property,只会生成方法的声明,不会生成方法的实现和带_下划线的成员变量

@end
