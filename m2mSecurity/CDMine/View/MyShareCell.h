//
//  MyShareCell.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyShareCell : UITableViewCell

@property (nonatomic, strong)TuyaSmartShareDeviceModel *model;

@property (nonatomic, assign) NSInteger memberId;

@property (nonatomic, copy) void(^reloadBlock)(void);

@end

NS_ASSUME_NONNULL_END
