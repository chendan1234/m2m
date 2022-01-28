//
//  NetFirstView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetFirstView : UIView

+(instancetype)reload;

@property (nonatomic, copy)void(^nextBlcok)(void);

@property (nonatomic, assign)BOOL isWangGuan;

@end

NS_ASSUME_NONNULL_END
