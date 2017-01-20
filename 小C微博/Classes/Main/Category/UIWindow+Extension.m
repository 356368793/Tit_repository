//
//  UIWindow+Extension.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/2.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "MainViewController.h"
#import "NewfeatureController.h"

@implementation UIWindow (Extension)

- (void)switchRootViewController
{
    // 取出原始版本号和当前版本号
    NSString *key = @"CFBundleVersion";
    // 当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 原始版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // 比较版本号
    if ([currentVersion isEqualToString:lastVersion]) {
        self.rootViewController = [[MainViewController alloc] init];
    } else {
        self.rootViewController = [[NewfeatureController alloc] init];
        
        // 将版本号存入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
