//
//  NSDate+Extension.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/6.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *  是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  是否为今天
 */
- (BOOL)isToday;

/**
 *  是否为今年
 */
- (BOOL)isThisYear;

@end
