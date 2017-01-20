//
//  AccountTool.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/2.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "AccountTool.h"
#import "Account.h"
#define AccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation AccountTool

/**
 *  存储账号信息
 */
+ (void)saveAccount:(Account *)account
{
    // 将返回的数据转为模型，存进沙盒
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
}

/**
 *  返回账号信息
 */
+ (Account *)account
{
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    
    // 验证是否过期
    long long expires_in = [account.expires_in longLongValue];
    
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    
    NSDate *now = [NSDate date];
    
//    Log(@"%@ %lld %@",expiresTime, expires_in, now);
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) { // 过期
        return nil;
    }
    // NSComparisonResult) {NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending};
    return account;
}

@end
