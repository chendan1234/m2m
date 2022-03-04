//
//  AppDelegate.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/11.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "CDLoginViewController.h"
#import "NewFeatureViewController.h"
#import "CameraDoorbellManager.h"

#import <UserNotifications/UserNotifications.h>

#import "HomeViewController.h"
#import "ArmInfoViewController.h"

@import Firebase;

@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@property (nonatomic, strong)TabBarViewController *tabberVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    #ifdef DEBUG
//    [[TuyaSmartSDK sharedInstance] setDebugMode:YES];
    #else
    #endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KNewFeature]) {
        if ([CDAppUser getUser].isLogin) {
            self.tabberVC = [[TabBarViewController alloc]init];
            self.window.rootViewController = self.tabberVC;
        }else{
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CDLoginViewController alloc]init]];
        }
    }else{
        self.window.rootViewController = [[NewFeatureViewController alloc] init];
    }
    [self.window makeKeyAndVisible];
    
    [self tuya];//涂鸦
    [self firebase];//Firebase 自己的推送
    [self pushWith:application];//推送
    
    return YES;
}

-(void)tuya{
    [[TuyaSmartSDK sharedInstance] startWithAppKey:@"rjvtrskdsgp4mhdep8mw" secretKey:@"3n3fpe3uuhpxxu3kqfrwjhpqt4ehfxjx"];
    // Doorbell Observer. If you have a doorbell device
    [[CameraDoorbellManager sharedInstance] addDoorbellObserver];
}

-(void)firebase{
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
}

-(void)pushWith:(UIApplication *)application{
    [application registerForRemoteNotifications];
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            //iOS10需要加下面这段代码。
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
            [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"request authorization succeeded!");
                }
            }];
        }
}

#pragma mark ----FIRMessaging代理方法----
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken{
    NSLog(@"registration token: %@", fcmToken);
    [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:KFcmToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册远程通知失败: %@", error);
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [TuyaSmartSDK sharedInstance].deviceToken = deviceToken;
    [FIRMessaging messaging].APNSToken = deviceToken;
}

// APP 在前后台都可以收到通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"推送消息 --- %@",userInfo);
    
    if ([userInfo objectForKey:@"pushId"]) {// 是自己的推送
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KHaveNewNoti object:nil];
            return;
        }else{
            self.tabberVC.selectedIndex = 1;
//            NSInteger currentNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
//            currentNumber = currentNumber +1;
//            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:currentNumber];
            [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"pushId"] forKey:KMeNoti];
        }

    }else{
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            return;
        }else{
//            NSInteger currentNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
//            currentNumber = currentNumber +1;
//            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:currentNumber];
            [[NSUserDefaults standardUserDefaults] setObject:KRecNoti forKey:KRecNoti];
        }
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}







@end
