//
//  StatusTool.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/21.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusTool : NSObject

+ (NSArray *)statusesWithParams:(NSDictionary *)params;

+ (void)saveStatuses:(NSArray *)statuses;

@end
