//
//  UICollectionView+Empty.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (Empty)

//支持自定义noteView
@property (nonatomic) UIView * noteView;

-(void)setupYWith:(NSInteger)orginY;

//refreshBtnImg为nil则不展示Btn
- (void)addNoteViewWithpicName:(NSString *)picName noteText:(NSString *)noteText refreshBtnImg:(NSString *)btnImg orginY:(NSInteger)orginY;

@end

NS_ASSUME_NONNULL_END
