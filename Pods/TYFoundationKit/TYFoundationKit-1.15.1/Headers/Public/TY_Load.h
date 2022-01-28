//
//  TY_Load.h
//  TYFoundationKit
//
//  Created by Rui on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, TYLoadAt) {
    /**
     *  准备执行main函数，优先级最高
     */
    TYLoadAtPreMain = 0,
    /**
     *  应用进入活跃状态, 在PreMain之后
     */
    TYLoadAtAppLaunched,
    /**
     *  遥远的时间, 大致在 becomeActive 执行完后 5s
     */
    TYLoadAtIdleTime,

    /////
    TYLoadAtN
};

FOUNDATION_EXTERN void ty_load_async(TYLoadAt at, void (^block)(void));

/*
 @param sort  数值越低在同级别中越早执行, 默认100
 */
FOUNDATION_EXTERN void ty_load_main(TYLoadAt at, NSInteger sort, void (^block)(void)) __attribute__((overloadable));

FOUNDATION_EXTERN void ty_load_main(TYLoadAt at, void (^block)(void)) __attribute__((overloadable));




NS_ASSUME_NONNULL_END
