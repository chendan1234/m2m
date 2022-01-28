//
//  MessageCell.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/9.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell

@property (nonatomic, strong)MessageModel *model;

@end

NS_ASSUME_NONNULL_END
