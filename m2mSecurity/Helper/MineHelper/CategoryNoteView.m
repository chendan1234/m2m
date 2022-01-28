//
//  CategoryNoteView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/27.
//

#import "CategoryNoteView.h"

@interface CategoryNoteView ()

@property (nonatomic)UIImageView *bgImgView;
@property (nonatomic)UILabel *noteLabel;

@end

@implementation CategoryNoteView

- (instancetype)newNoteViewInView:(UIView *)view{
    CGRect frame = view.bounds;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setImageVOriginY:(NSInteger)y{
    
}

- (void)setupViews {
    
    [self addSubview:self.bgImgView];
    [self addSubview:self.noteLabel];
}


- (void)addNoteViewWithpicName:(NSString *)picName noteText:(NSString *)noteText refreshBtnImg:(NSString *)btnImg {
    
    self.bgImgView.image = [UIImage imageNamed:picName];
    self.noteLabel.text = noteText;
    
    if (btnImg) {
        [self addSubview:self.refreshBtn];
        [self.refreshBtn setBackgroundImage:[UIImage imageNamed:btnImg] forState:UIControlStateNormal];
        self.refreshBtn.frame = CGRectMake(0, 0, self.refreshBtn.currentBackgroundImage.size.width, self.refreshBtn.currentBackgroundImage.size.height);
    }
    
//    [self layoutCustomViews];
}

//masony~也没有
//- (void)layoutCustomViews {
//
//    UIView *  refreshBtnLayoutView = (self.noteLabel.text.length > 0)?self.noteLabel:self.bgImgView;
//    //防止一些奇怪的方式二次调用addNoteViewWithpicName导致二次约束/虽然还没出现
//    //so----mas_updateConstraints
//    [self.bgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.centerY.mas_equalTo(self).offset(- 20 - self.bgImgView.image.size.height/2);
//        make.width.mas_equalTo(self.bgImgView.image.size.width);
//        make.height.mas_equalTo(self.bgImgView.image.size.height);
//    }];
//
//    [self.noteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.mas_equalTo(self.bgImgView.mas_bottom).offset(20);
//    }];
//
//    if (_refreshBtn) {
//        [self.refreshBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.mas_equalTo(refreshBtnLayoutView.mas_bottom).offset(20);
//        }];
//    }
//}



//demo懒得导masony~用frame凑合凑合
- (void)layoutSubviews {

//
    
    if (self.imageVY == 21) {
        self.bgImgView.frame = CGRectMake(self.frame.size.width/2 - self.bgImgView.image.size.width/2, self.imageVY, self.bgImgView.image.size.width, self.bgImgView.image.size.height);
    }else{
        self.bgImgView.frame = CGRectMake((DEVICE_WIDRH - self.bgImgView.image.size.width)/2, self.imageVY, self.bgImgView.image.size.width, self.bgImgView.image.size.height);
    }
    
    

    self.noteLabel.frame = CGRectMake(0, CGRectGetMaxY(self.bgImgView.frame) + 20, self.frame.size.width, 20);

    if (self.refreshBtn) {

        if (self.noteLabel.text.length > 0) {
            self.refreshBtn.center = CGPointMake(self.frame.size.width/2.0, CGRectGetMaxY(self.noteLabel.frame) + 25 + self.refreshBtn.currentBackgroundImage.size.height / 2.0);
        }else {
            //无提示文字时、将btn上移
            self.refreshBtn.center = CGPointMake(self.frame.size.width/2.0, CGRectGetMaxY(self.bgImgView.frame) + 25 + self.refreshBtn.currentBackgroundImage.size.height / 2.0);
        }
    }
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
    }
    return _bgImgView;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentCenter;
        _noteLabel.font = [UIFont systemFontOfSize:13.0];
//        _noteLabel.textColor = [UIColor hexChangeFloat:@"a3a3a3"];
    }
    return _noteLabel;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [[UIButton alloc] init];
//        _refreshBtn.eventInterval = 3.0;
    }
    return _refreshBtn;
}



@end
