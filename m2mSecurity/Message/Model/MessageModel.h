//
//  MessageModel.h
//  m2mSecurity
//
//  Created by chendan on 2021/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

//body = fsdgff;
//createTime = 1630651269000;
//isRead = 0;
//pushId = 64ce5455a50c43f4b4c2b519b0e11c05;
//title = fsfsf;
//userId = 110fda88a75e4aefbfcc685ea928f79f;

@property (nonatomic, strong)NSString *body;
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *pushId;
@property (nonatomic, assign)BOOL isRead;
@property (nonatomic, assign)NSInteger createTime;


@end

NS_ASSUME_NONNULL_END
