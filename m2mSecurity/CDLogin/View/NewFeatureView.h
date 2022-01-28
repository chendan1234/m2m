//
//  NewFeatureView.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/28.
//

#import <UIKit/UIKit.h>
#import "NewFeatureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewFeatureView : UIView

+(instancetype)reload;
@property (weak, nonatomic) IBOutlet UIButton *tiYanBtn;

@property (nonatomic, strong)NewFeatureModel *model;

@end

NS_ASSUME_NONNULL_END
