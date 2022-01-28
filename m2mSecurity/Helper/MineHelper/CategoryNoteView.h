//
//  CategoryNoteView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryNoteView : UIView

@property (nonatomic) UIButton *refreshBtn;

@property (nonatomic, assign)NSInteger imageVY;

- (instancetype)newNoteViewInView:(UIView *)view;

- (void)addNoteViewWithpicName:(NSString *)picName noteText:(NSString *)noteText refreshBtnImg:(NSString *)btnImg;

@end

NS_ASSUME_NONNULL_END
