//
//  CDAppUser.m
//  security
//
//  Created by chendan on 2021/6/18.
//

#import "CDAppUser.h"
#import "CDHelper.h"
#import <MJExtension.h>

@implementation CDAppUser

+(CDAppUser *)getUser{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"KAppUser"];
    if (jsonStr == nil) {
        return  [[CDAppUser alloc]init];
    }
    NSDictionary *dic = [CDHelper jsonToDic:jsonStr];
    CDAppUser *user = [CDAppUser mj_objectWithKeyValues:dic];
    return user;
}



+(void)setUser:(CDAppUser *)user{
    NSString *jsonStr = [user mj_JSONString];
    [[NSUserDefaults standardUserDefaults]setObject:jsonStr forKey:@"KAppUser"];
}



@end
