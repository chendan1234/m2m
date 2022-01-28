//
//  NetWiredSearchView.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWiredSearchView : UIView

+(instancetype)reload;

@property (nonatomic, copy) void(^nextBlock)(void);

-(dispatch_source_t)countTime;

@end

NS_ASSUME_NONNULL_END
