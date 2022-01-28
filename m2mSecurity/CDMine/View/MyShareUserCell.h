//
//  MyShareUserCell.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/7.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MyShareUserCell : UITableViewCell

@property (nonatomic, strong)TuyaSmartShareMemberModel *userModel;

@property (nonatomic, assign)NSInteger type;

@property (nonatomic, copy) void(^deleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
