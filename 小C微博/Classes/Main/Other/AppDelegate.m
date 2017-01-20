//
//  AppDelegate.m
//  项目之微博
//
//  Created by 肖晨 on 15/7/27.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "AppDelegate.h"
#import "OauthViewController.h"
#import "AccountTool.h"
#import "SDWebImageManager.h"
#import "HomeViewController.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 沙盒路径
//    Account *account = [AccountTool account];

//    NSDictionary *account = [NSDictionary dictionaryWithContentsOfFile:path];
    
//    if (account) { // 如果沙盒存在这个文件
//        
//        [self.window switchRootViewController];
//        
//    } else {
//        self.window.rootViewController = [[OauthViewController alloc] init];
//    }
    self.window.rootViewController = [[MainViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

/**
 didFinishLaunchingWithOptions
 */

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 *  程序进入后台时调用
 */
- (void)applicationDidEnterBackground:(UIApplication*)application
{
    UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:task];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}

@end
