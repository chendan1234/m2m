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

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[TuyaSmartSDK sharedInstance] startWithAppKey:@"rjvtrskdsgp4mhdep8mw" secretKey:@"3n3fpe3uuhpxxu3kqfrwjhpqt4ehfxjx"];
    // Doorbell Observer. If you have a doorbell device
    [[CameraDoorbellManager sharedInstance] addDoorbellObserver];
    
    #ifdef DEBUG
//    [[TuyaSmartSDK sharedInstance] setDebugMode:YES];
    #else
    #endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KNewFeature]) {
        if ([CDAppUser getUser].isLogin) {
            self.window.rootViewController = [[TabBarViewController alloc]init];
        }else{
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CDLoginViewController alloc]init]];
        }
    }else{
        self.window.rootViewController = [[NewFeatureViewController alloc]init];
    }
    [self.window makeKeyAndVisible];
    
    [self pushWith:application];//推送
    
    return YES;
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
                if (granted) {
                    //点击允许
                } else {
                    //点击不允许
                }
            }];
        }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [TuyaSmartSDK sharedInstance].deviceToken = deviceToken;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"userInfo444--------%@",userInfo);
}






@end
