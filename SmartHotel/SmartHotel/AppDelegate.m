//
//  AppDelegate.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "AppDelegate.h"
#import "SHRoomViewController.h"
#import "SHSoundTools.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/// 接收到了本地的闹钟通知
- (void)recivceAlarmClock:(UILocalNotification *)notification {
    
    if (!notification) {
        return;
    }
   
//    while (true) {
    
        NSString *soundName = [notification.userInfo objectForKey:
                               @"alarmSongName"];
        
        [[SHSoundTools shareSHSoundTools] playSoundWithName:soundName];
        
        NSInteger time = [[notification.userInfo objectForKey:
                           @"alarmIntervalTime"] integerValue];
        
        [NSThread sleepForTimeInterval:time * 60];
        
        BOOL isOpen = [[NSUserDefaults standardUserDefaults]
                  boolForKey:alarmClockOnOffKey];
        
//        if (!isOpen) {
//
//            [[SHSoundTools shareSHSoundTools] stopSoundWithName:soundName];
//            break;
//        }
    
//    printLog(@"%d", isOpen);
//    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:
    (UILocalNotification *)notification {
    
    [self recivceAlarmClock:notification];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.语言环境初始化
    [[SHLanguageTools shareSHLanguageTools] copyLanguagePlist];
    [[SHLanguageTools shareSHLanguageTools] setLanguage];
    
    // 2.数据库文件拷贝
    [SHSQLManager shareSHSQLManager];
    
    // 3.启动窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[SHRoomViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    // 注册通知
    [self registerLocalNotification];
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    [self recivceAlarmClock:localNotification];
    
    return YES;
}


/// 注册本地通知
- (void)registerLocalNotification {
     
    if ([[[UIApplication sharedApplication] currentUserNotificationSettings] types] != UIUserNotificationTypeNone) {
        
        return;
    }
    
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting
     ];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
