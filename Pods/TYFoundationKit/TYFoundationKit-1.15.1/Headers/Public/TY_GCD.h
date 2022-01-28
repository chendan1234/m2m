//
//  TY_GCD.h
//  TYFoundationKit
//
//  Created by Rui on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TY_GCD)

///可取消的 异步调用block
+ (void)ty_asyncBlock:(void (^)(void))block onQueue:(dispatch_queue_t)queue afterSecond:(double)second forKey:(NSString *)key;

///取消之前的block
+ (void)ty_cancelBlockForKey:(NSString *)key;

///是否存在这个异步block
+ (BOOL)ty_hasAsyncBlockForKey:(NSString *)key;

/// 获取默认优先级的queue
+ (dispatch_queue_t)ty_defaultQualityQueue;

@end

NS_ASSUME_NONNULL_END
