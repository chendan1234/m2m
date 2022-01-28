//
//  MenLingView.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenLingView : UIView

+(instancetype)reload;

@property (nonatomic, copy) void(^shengYin)(BOOL isMute);//声音开关
@property (nonatomic, copy) void(^luZhi)(BOOL isIng);//录制视频
@property (nonatomic, copy) void(^shuoHua)(BOOL isIng);//对话
@property (nonatomic, copy) void(^jiePing)(void);//截图
@property (nonatomic, copy) void(^quanPing)(BOOL isQuan);//全屏
@property (nonatomic, copy) void(^lisi)(void);//历史视频

@property (weak, nonatomic) IBOutlet UIView *videoContainer;//视频播放view

@property (nonatomic, strong)TuyaSmartDeviceModel *model;

@end

NS_ASSUME_NONNULL_END
