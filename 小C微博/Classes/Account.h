//
//  Account.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/2.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>
@property (copy, nonatomic) NSString *access_token;
@property (copy, nonatomic) NSString *expires_in;
@property (copy, nonatomic) NSString *uid;
@property (strong, nonatomic) NSDate *created_time;
@property (copy, nonatomic) NSString *name;
+ (instancetype)initWithDict:(NSDictionary *)dict;
@end
