//
//  UICollectionView+Empty.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/27.
//

#import "UICollectionView+Empty.h"
#import <objc/runtime.h>
#import "CategoryNoteView.h"


static char noteViewKey = 'a';





@implementation UICollectionView (Empty)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView *collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        [collectionV swizzleMethod:@selector(reloadData) withMethod:@selector(KTreloadData)];
    });
}

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (UIView *)noteView
{
    return objc_getAssociatedObject(self, &noteViewKey);
}

- (void)setNoteView:(UIView *)noteView
{
    objc_setAssociatedObject(self, &noteViewKey, noteView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)setupYWith:(NSInteger)orginY{
    
}

- (void)addNoteViewWithpicName:(NSString *)picName noteText:(NSString *)noteText refreshBtnImg:(NSString *)btnImg orginY:(NSInteger)orginY{
    
    CategoryNoteView *noteView = [[CategoryNoteView alloc] newNoteViewInView:self];
    noteView.imageVY = orginY;
    
    [noteView addNoteViewWithpicName:picName noteText:noteText refreshBtnImg:btnImg];
    if (btnImg) {
        [noteView.refreshBtn addTarget:self action:@selector(noteViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    //self.noteView可能有两种。另一种为使用者自定义传入
    self.noteView = noteView;
}

- (void)noteViewBtnClick {
    [self.noteView removeFromSuperview];
//    demo代码里没有mj刷新~
//    if (self.mj_header) {
//        [self.mj_header beginRefreshing];
//    }
}

- (void)KTreloadData {
    [self KTreloadData];
    //这里。如果没有使用类别操作tableView。则不进行新代码注入。
    if (self.noteView) {
        [self checkDataSource];
    }
}

//工作代码~就这么几行
- (void)checkDataSource {
    //需求是没有数据则不允许下拉刷新。如果不要阻隔下拉动作。则把self.noteView置于self上、或者将self.noteView的层级调至self之下即可
    id <UICollectionViewDataSource> dataSource = self.dataSource;
    NSInteger numberOfSections = [dataSource numberOfSectionsInCollectionView:self];
    
    for (int i = 0; i < numberOfSections; i++) {
        if ([dataSource collectionView:self numberOfItemsInSection:i] !=0) {
            [self.noteView removeFromSuperview];
            return;
        }
    }
                [self addSubview:self.noteView];
//    [self.superview addSubview:self.noteView];
    
}


@end



