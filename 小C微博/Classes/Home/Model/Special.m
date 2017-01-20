//
//  Special.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/13.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "Special.h"

@implementation Special

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}

@end
