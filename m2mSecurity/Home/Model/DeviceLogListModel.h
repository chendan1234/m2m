//
//  DeviceLogListModel.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceLogListModel : NSObject

//dpId = 14;
//timeStamp = 1630452106;
//timeStr = "2021-09-01 07:21:46";
//value = high;

@property (nonatomic, strong)NSString *dpId;
@property (nonatomic, assign)NSInteger timeStamp;
@property (nonatomic, strong)NSString *timeStr;
@property (nonatomic, strong)NSString *value;
@property (nonatomic, strong)NSString *name;

@end

NS_ASSUME_NONNULL_END
