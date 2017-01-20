//
//  AccountTool.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/2.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountTool : NSObject

+ (void)saveAccount:(Account *)account;

+ (Account *)account;

@end
