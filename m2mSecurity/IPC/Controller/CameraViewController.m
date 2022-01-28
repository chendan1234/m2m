//
//  CameraViewController.m
//  TuyaSmartIPCDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "CameraViewController.h"
#import "CameraControlView.h"
#import "CameraPlaybackViewController.h"
#import "CameraSettingViewController.h"
#import "CameraCloudViewController.h"
#import "CameraMessageViewController.h"
#import "CameraPermissionUtil.h"
#import <TuyaSmartCameraM/TuyaSmartCameraM.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraVideoView.h"

#define VideoViewWidth [UIScreen mainScreen].bounds.size.width
#define VideoViewHeight ([UIScreen mainScreen].bounds.size.width / 16 * 9)

#define kControlTalk        @"talk"
#define kControlRecord      @"record"
#define kControlPhoto       @"photo"
#define kControlPlayback    @"playback"
#define kControlCloud       @"Cloud"
#define kControlMessage     @"message"

@interface CameraViewController ()<TuyaSmartCameraDelegate, CameraControlViewDelegate, TuyaSmartCameraDPObserver>

@property (nonatomic, strong) NSString *devId;

@property (nonatomic, strong) UIView *videoContainer;//视频的父控件

@property (nonatomic, strong) CameraControlView *controlView;//6个按钮

@property (nonatomic, strong) UIButton *soundButton;//声音按钮(是否关闭)

@property (nonatomic, strong) UIButton *hdButton;//高清按钮

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;//指示器

@property (nonatomic, strong) UILabel *stateLabel;//状态 (加载中...)

@property (nonatomic, strong) UIButton *retryButton;//重置按钮

@property (nonatomic, strong) TuyaSmartDevice *device;

@property (nonatomic, strong) TuyaSmartCameraDPManager *dpManager;//功能点
/// Camera control class
@property (nonatomic, strong) id<TuyaSmartCameraType> cameraType;//视频控制

@property (nonatomic, strong) CameraVideoView *videoView; //视频
/// Record last mute status
@property (nonatomic, assign) BOOL lastMuted; //最后的清晰度
/// camera status
@property (nonatomic, assign, getter=isConnecting)      BOOL connecting;//是否正在连接

@property (nonatomic, assign, getter=isConnected)       BOOL connected;//是否已连接

@property (nonatomic, assign, getter=isPreviewing)      BOOL previewing;//是否正在实时播放

@property (nonatomic, assign, getter=isMuted)           BOOL muted;//是否静音

@property (nonatomic, assign, getter=isTalking)         BOOL talking;//是否正在说话

@property (nonatomic, assign, getter=isRecording)       BOOL recording;//是否正在录像

@property (nonatomic, assign, getter=isHD)              BOOL HD;//是否高清

@end

@implementation CameraViewController

- (void)dealloc {
    [self disConnect];
    [self.cameraType destory];
}

- (instancetype)initWithDeviceId:(NSString *)devId {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _devId = devId;
        _device = [TuyaSmartDevice deviceWithDeviceId:devId];
        _dpManager = [[TuyaSmartCameraDPManager alloc] initWithDeviceId:devId];
        _cameraType = [TuyaSmartCameraFactory cameraWithP2PType:@(_device.deviceModel.p2pType) deviceId:_device.deviceModel.devId delegate:self];
        _muted = YES;
        _lastMuted = _muted;
        _videoView = [[CameraVideoView alloc] initWithFrame:CGRectZero];
        _videoView.renderView = _cameraType.videoView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleInterruption:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:[AVAudioSession sharedInstance]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"tp_top_bar_more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    self.title = self.device.deviceModel.name;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.videoContainer];
    [self.view addSubview:self.indicatorView];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.retryButton];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.soundButton];
    [self.view addSubview:self.hdButton];
    
    // Tips: Speak、Record、Take Photo、Sound、HD, these buttons can be available after received video data.
    // Playback、Cloud Storage、Message, these buttons can be available after camera is connected.
    [self.retryButton addTarget:self action:@selector(retryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.soundButton addTarget:self action:@selector(soundAction) forControlEvents:UIControlEventTouchUpInside];
    [self.hdButton addTarget:self action:@selector(hdAction) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self retryAction];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self disConnect];
}

//到前台
- (void)willEnterForeground {
    [self retryAction];
}

//到后台
- (void)didEnterBackground {
    [self stopPreview];
    [self disConnect];
}

#pragma mark - Action
//设置
- (void)settingAction {
    CameraSettingViewController *settingVC = [CameraSettingViewController new];
    settingVC.devId = self.devId;
    settingVC.dpManager = self.dpManager;
    [self.navigationController pushViewController:settingVC animated:YES];
}

//重新加载
- (void)retryAction {
    if (!self.device.deviceModel.isOnline) {
        self.stateLabel.hidden = NO;
        self.stateLabel.text = NSLocalizedStringFromTable(@"title_device_offline", @"IPCLocalizable", @"");
        return;
    }
    if ([self isDoorbell]) {
        [self.device awakeDeviceWithSuccess:nil failure:nil];
    }
    [self connectCamera];
    [self showLoadingWithTitle:NSLocalizedStringFromTable(@"loading", @"IPCLocalizable", @"")];
    self.retryButton.hidden = YES;
}

//声音
- (void)soundAction {
    [self enableMute:!self.isMuted];
}

//清晰度
- (void)hdAction {
    TuyaSmartCameraDefinition definition = !self.isHD ? TuyaSmartCameraDefinitionHigh : TuyaSmartCameraDefinitionStandard;
    [self.cameraType setDefinition:definition];//设置清晰度
}

//说话
- (void)talkAction {
    if ([CameraPermissionUtil microNotDetermined]) {
        [CameraPermissionUtil requestAccessForMicro:^(BOOL result) {
            if (result) {
                [self _talkAction];
            }
        }];
    }else if ([CameraPermissionUtil microDenied]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedStringFromTable(@"Micro permission denied", @"IPCLocalizable", @"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"ipc_settings_ok", @"IPCLocalizable", @"") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [self _talkAction];
    }
}

//实时对讲
- (void)_talkAction {
    if (self.isTalking) {
        [self stopTalk];
        [self.controlView deselectedControl:kControlTalk];
    }else {
        [self.cameraType startTalk];//说话
        _talking = YES;
    }
}

//停止说话
- (void)stopTalk {
    if (self.isTalking) {
        [self.cameraType stopTalk];//关闭 App 到摄像机的声音通道
        _talking = NO;
    }
}

//录像
- (void)recordAction {
    [self checkPhotoPermision:^(BOOL result) {
        if (result) {
            if (self.isRecording) {
                [self stopRecord];
            }else {
                [self startRecord];
            }
        }
    }];
}

//拍照
- (void)photoAction {
    [self checkPhotoPermision:^(BOOL result) {
        if (result) {
            [self.cameraType snapShoot];//视频截图，图片保存在手机系统相册
        }
    }];
}

//检测拍照是否允许
- (void)checkPhotoPermision:(void(^)(BOOL result))complete {
    if ([CameraPermissionUtil isPhotoLibraryNotDetermined]) {
        [CameraPermissionUtil requestPhotoPermission:complete];
    }else if ([CameraPermissionUtil isPhotoLibraryDenied]) {
        [self showAlertWithMessage:NSLocalizedStringFromTable(@"Photo library permission denied", @"IPCLocalizable", @"") complete:nil];
        !complete?:complete(NO);
    }else {
        !complete?:complete(YES);
    }
}

#pragma mark - Operation

//是否是低功率设备
- (BOOL)isDoorbell {
    return self.device.deviceModel.isLowPowerDevice;
}

//连接摄像头
- (void)connectCamera {
    if (self.isConnected || self.isConnecting) {
        return;
    }
    _connecting = YES;
    [self.controlView disableAllControl];
    [self.cameraType connectWithMode:TuyaSmartCameraConnectAuto];
}

//开始展示
- (void)startPreview {
    [self.videoContainer addSubview:self.videoView]; //添加播放试图
    self.videoView.frame = self.videoContainer.bounds;
    
    [self stopPlayback];
    [self.cameraType startPreview];
    _previewing = YES;
    [self enableMute:self.isMuted];
}

//停止展示
- (void)stopPreview {
    [self stopRecord];
    [self stopTalk];
    [self.cameraType stopPreview];
}

//开始录像
- (void)startRecord {
    if (self.isRecording) {
        return;
    }
    if (self.previewing) {
        [self.cameraType startRecord];
        _recording = YES;
    }
}

//停止录像
- (void)stopRecord {
    if (self.isRecording) {
        [self.cameraType stopRecord];
    }
}

//视频声音开关  是否静音
- (void)enableMute:(BOOL)isMute {
    [self.cameraType enableMute:isMute forPlayMode:TuyaSmartCameraPlayModePreview];
}

//停止回放
- (void)stopPlayback {
    if (self.isRecording) {
        [self.cameraType stopRecord];
    }
    [self.cameraType stopPlayback];
}

//断开链接
- (void)disConnect {
    [self stopPreview];
    [self stopPlayback];
    [self.cameraType disConnect];
    self.connected = NO;
    self.connecting = NO;
}

#pragma mark - Loading && Alert
- (void)showLoadingWithTitle:(NSString *)title {
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
    self.stateLabel.hidden = NO;
    self.stateLabel.text = title;
}

- (void)stopLoading {
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
    self.stateLabel.hidden = YES;
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"ty_alert_confirm", @"IPCLocalizable", @"") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)msg complete:(void(^)(void))complete {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"ipc_settings_ok", @"IPCLocalizable", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        !complete?:complete();
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - CameraControlViewDelegate
//选择功能
- (void)controlView:(CameraControlView *)controlView didSelectedControl:(NSString *)identifier {
    if ([identifier isEqualToString:kControlTalk]) {//说话
        [self talkAction];
        return;
    }
    if ([identifier isEqualToString:kControlPlayback]) {//回放
        CameraPlaybackViewController *vc = [[CameraPlaybackViewController alloc] initWithDeviceId:self.devId];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([identifier isEqualToString:kControlCloud]) {//云存储
        CameraCloudViewController *vc = [CameraCloudViewController new];
        vc.devId = self.devId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([identifier isEqualToString:kControlMessage]) {//消息
        CameraMessageViewController *vc = [CameraMessageViewController new];
        vc.devId = self.devId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    BOOL needPhotoPermission = [identifier isEqualToString:kControlPhoto] || [identifier isEqualToString:kControlRecord];
    if (needPhotoPermission) {
        if ([CameraPermissionUtil isPhotoLibraryNotDetermined]) {
            [CameraPermissionUtil requestPhotoPermission:^(BOOL result) {
                if (result) {
                    if ([identifier isEqualToString:kControlRecord]) {//录像
                        [self recordAction];
                    } else if ([identifier isEqualToString:kControlPhoto]) {//拍照
                        [self photoAction];
                    }
                }
            }];
        }else if ([CameraPermissionUtil isPhotoLibraryDenied]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedStringFromTable(@"Photo library permission denied", @"IPCLocalizable", @"") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"ipc_settings_ok", @"IPCLocalizable", @"") style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            if ([identifier isEqualToString:kControlRecord]) {//录像
                [self recordAction];
            } else if ([identifier isEqualToString:kControlPhoto]) {//拍照
                [self photoAction];
            }
        }
    }
}

#pragma mark - TuyaSmartCameraDelegate
//摄像头链接 连接成功
- (void)cameraDidConnected:(id<TuyaSmartCameraType>)camera {
    [self.cameraType enterPlayback];
    _connecting = NO;
    _connected = YES;
    NSDictionary *config = [TuyaSmartP2pConfigService getCachedConfigWithDeviceModel:self.device.deviceModel];
    [self audioAttributesMap:[config objectForKey:@"audioAttributes"]];
    [self startPreview]; // 需要 P2P 连接成功后再开始预览
}

//摄像头断开链接
- (void)cameraDisconnected:(id<TuyaSmartCameraType>)camera {
    
    // P2P 连接被动断开，一般为网络波动导致
    _connecting = NO;
    _connected = NO;
    [self.controlView disableAllControl];
    self.retryButton.hidden = NO;
}

//视频直播已经成功开始播放
- (void)cameraDidBeginPreview:(id<TuyaSmartCameraType>)camera {
    [self.cameraType getHD]; //获取当前视频图像的清晰度，结果通过代理方法返回。
    [self.controlView enableAllControl];
    [self stopLoading];
}

//视频直播已经成功停止播放
- (void)cameraDidStopPreview:(id<TuyaSmartCameraType>)camera {
    _previewing = NO;
}

//开始说话  App 到摄像机的声音通道成功开启代理回调。
- (void)cameraDidBeginTalk:(id<TuyaSmartCameraType>)camera {
    [self.controlView selectedControl:kControlTalk];
}

//停止说话 App 到摄像机的声音通道成功关闭的代理回调。
- (void)cameraDidStopTalk:(id<TuyaSmartCameraType>)camera {
    _talking = NO;
}

//拍照成功
- (void)cameraSnapShootSuccess:(id<TuyaSmartCameraType>)camera {
    [self showAlertWithMessage:NSLocalizedStringFromTable(@"ipc_multi_view_photo_saved", @"IPCLocalizable", @"") complete:nil];
}

//开始录像
- (void)cameraDidStartRecord:(id<TuyaSmartCameraType>)camera {
    [self.controlView selectedControl:kControlRecord];
}

//停止录像
- (void)cameraDidStopRecord:(id<TuyaSmartCameraType>)camera {
    _recording = NO;
    [self.controlView deselectedControl:kControlRecord];
    [self showAlertWithMessage:NSLocalizedStringFromTable(@"ipc_multi_view_video_saved", @"IPCLocalizable", @"")];
}

//视频清晰度状态变化代理回调
- (void)camera:(id<TuyaSmartCameraType>)camera definitionChanged:(TuyaSmartCameraDefinition)definition{
    _HD = definition >= TuyaSmartCameraDefinitionHigh;
    NSString *imageName = @"ty_camera_control_sd_normal";
    if (_HD) {
        imageName = @"ty_camera_control_hd_normal";
    }
    [self.hdButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

//视频声音开关结果代理回调。
- (void)camera:(id<TuyaSmartCameraType>)camera didReceiveMuteState:(BOOL)isMute playMode:(TuyaSmartCameraPlayMode)playMode {
    if (playMode == TuyaSmartCameraPlayModePreview) {
        _muted = isMute;
    }
    
    NSString *imageName = @"ty_camera_soundOn_icon";
    if (isMute) {
        imageName = @"ty_camera_soundOff_icon";
    }
    [self.soundButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

//视频分辨率改变的代理方法，实时视频直播或者录像回放刚开始时也会调用
- (void)camera:(id<TuyaSmartCameraType>)camera resolutionDidChangeWidth:(NSInteger)width height:(NSInteger)height {
    [self.cameraType getDefinition];
}

//camera 控制出现了一个错误，错误回调
- (void)camera:(id<TuyaSmartCameraType>)camera didOccurredErrorAtStep:(TYCameraErrorCode)errStepCode specificErrorCode:(NSInteger)errorCode {
    if (errStepCode == TY_ERROR_CONNECT_FAILED || errStepCode == TY_ERROR_CONNECT_DISCONNECT) {//连接错误或连接失败
        _connecting = NO;
        _connected = NO;
        [self stopLoading];
        self.retryButton.hidden = NO;
        [self.controlView disableAllControl];
    }
    else if (errStepCode == TY_ERROR_START_PREVIEW_FAILED) {//实时视频播放失败
        _previewing = NO;
        [self stopLoading];
        self.retryButton.hidden = NO;
    }
    else if (errStepCode == TY_ERROR_START_TALK_FAILED) {//开启对讲失败
        _talking = NO;
        [self showAlertWithMessage:NSLocalizedStringFromTable(@"ipc_errmsg_mic_failed", @"IPCLocalizable", @"")];
    }
    else if (errStepCode == TY_ERROR_SNAPSHOOT_FAILED) {//拍照错误
        [self showAlertWithMessage:NSLocalizedStringFromTable(@"fail", @"IPCLocalizable", @"") complete:nil];
    }
    else if (errStepCode == TY_ERROR_RECORD_FAILED) {//开启或者停止视频录制失败
        _recording = NO;
        [self showAlertWithMessage:NSLocalizedStringFromTable(@"record failed", @"IPCLocalizable", @"")];
    }
}

#pragma mark - Private
- (void)audioAttributesMap:(NSDictionary *)attributes { //音频属性
    __block BOOL supportSound = NO;
    __block BOOL supportTalk = NO;
    BOOL couldChangeAudioMode = NO;
    if (!attributes) { return; }
    NSArray *hardwareCapability = [attributes objectForKey:@"hardwareCapability"];
    NSArray *callMode = [attributes objectForKey:@"callMode"];
    if (!hardwareCapability || hardwareCapability.count == 0) {
        return;
    }
    [hardwareCapability enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] == 1) {
            supportSound = YES;
        }
        if ([obj integerValue] == 2) {
            supportTalk = YES;
        }
    }];
    
    if (!callMode || callMode.count == 0) {
        return;
    }
    
    if (callMode.count >= 2) {
        couldChangeAudioMode = YES;
    }else {
        couldChangeAudioMode = NO;
    }
    
    NSLog(@"isSupportInstantTalkback:%@", @(couldChangeAudioMode));
    NSLog(@"isSupportTalk:%@", @(supportTalk));
    NSLog(@"isSupportSound:%@", @(supportSound));
}

#pragma mark - AudioSession implementations
// Incoming call sound recovery
- (void)handleInterruption:(NSNotification *)notification { //中断
    NSInteger type = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        // record last mute status
        _lastMuted = self.isMuted;
        // The call was not muted before, so it should be muted temporarily
        if (!self.isMuted) {
            [self enableMute:YES];
        }
    } else if (type == AVAudioSessionInterruptionTypeEnded) {
        // The call was not muted before, and the sound needs to be restored at this time
        if (!_lastMuted) {
            [self enableMute:NO];
            _lastMuted = YES;
        }
    }
}

#pragma mark - Accessor

//视频view
- (UIView *)videoContainer {
    if (!_videoContainer) {
        _videoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, APP_TOP_BAR_HEIGHT, VideoViewWidth, VideoViewHeight)];
        _videoContainer.backgroundColor = [UIColor blackColor];
    }
    return _videoContainer;
}

- (NSArray *)controlDatas {
    return @[@{
                 @"image": @"ty_camera_mic_icon",
                 @"title": NSLocalizedStringFromTable(@"ipc_panel_button_speak", @"IPCLocalizable", @""),
                 @"identifier": kControlTalk
                 },
             @{
                 @"image": @"ty_camera_rec_icon",
                 @"title": NSLocalizedStringFromTable(@"ipc_panel_button_record", @"IPCLocalizable", @""),
                 @"identifier": kControlRecord
                 },
             @{
                 @"image": @"ty_camera_photo_icon",
                 @"title": NSLocalizedStringFromTable(@"ipc_panel_button_screenshot", @"IPCLocalizable", @""),
                 @"identifier": kControlPhoto
                 },
             @{
                 @"image": @"ty_camera_playback_icon",
                 @"title": NSLocalizedStringFromTable(@"pps_flashback", @"IPCLocalizable", @""),
                 @"identifier": kControlPlayback
                 },
             @{
                 @"image": @"ty_camera_cloud_icon",
                 @"title": NSLocalizedStringFromTable(@"ipc_panel_button_cstorage", @"IPCLocalizable", @""),
                 @"identifier": kControlCloud
                 },
             @{
                 @"image": @"ty_camera_message",
                 @"title": NSLocalizedStringFromTable(@"ipc_panel_button_message", @"IPCLocalizable", @""),
                 @"identifier": kControlMessage
                 }
             ];
}

//控制view
- (CameraControlView *)controlView {
    if (!_controlView) {
        CGFloat top = VideoViewHeight + APP_TOP_BAR_HEIGHT;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height - top;
        _controlView = [[CameraControlView alloc] initWithFrame:CGRectMake(0, top, width, height)];
        _controlView.sourceData = [self controlDatas];
        _controlView.delegate = self;
    }
    return _controlView;
}

//声音button
- (UIButton *)soundButton {
    if (!_soundButton) {
        _soundButton = [[UIButton alloc] initWithFrame:CGRectMake(8, APP_TOP_BAR_HEIGHT + VideoViewHeight - 50, 44, 44)];
        [_soundButton setImage:[UIImage imageNamed:@"ty_camera_soundOff_icon"] forState:UIControlStateNormal];
    }
    return _soundButton;
}

// 高清button
- (UIButton *)hdButton {
    if (!_hdButton) {
        _hdButton = [[UIButton alloc] initWithFrame:CGRectMake(60, APP_TOP_BAR_HEIGHT + VideoViewHeight - 50, 44, 44)];
        [_hdButton setImage:[UIImage imageNamed:@"ty_camera_control_sd_normal"] forState:UIControlStateNormal];
    }
    return _hdButton;
}

//指示器
- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGPoint center = self.videoContainer.center;
        center.y -= 20;
        _indicatorView.center = center;
        _indicatorView.hidden = YES;
    }
    return _indicatorView;
}

//指示器下面的文字
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.indicatorView.frame) + 8, VideoViewWidth, 20)];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.hidden = YES;
    }
    return _stateLabel;
}

//重置button
- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, VideoViewWidth, 40)];
        _retryButton.center = self.videoContainer.center;
        [_retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_retryButton setTitle:NSLocalizedStringFromTable(@"connect failed, click retry", @"IPCLocalizable", @"") forState:UIControlStateNormal];
        _retryButton.hidden = YES;
    }
    return _retryButton;
}

@end
