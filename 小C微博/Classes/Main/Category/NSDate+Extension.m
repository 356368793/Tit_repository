//
//  NSDate+Extension.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/6.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM-dd";
    NSString *createStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    
    NSDate *createDate = [fmt dateFromString:createStr];
    NSDate *nowDate = [fmt dateFromString:nowStr];
    
    NSCalendarUnit unit = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateCmp = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    return dateCmp.day == 1 && dateCmp.month == 0;
}

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM-dd";
    NSString *createStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    
    NSDate *createDate = [fmt dateFromString:createStr];
    NSDate *nowDate = [fmt dateFromString:nowStr];
    
    NSCalendarUnit unit = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateCmp = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    return dateCmp.day == 0 && dateCmp.month == 0;
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *createDateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return createDateCmps.year == nowCmps.year;
}

@end
