//
//  LoadMoreFooter.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/3.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "LoadMoreFooter.h"

@implementation LoadMoreFooter

+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:nil options:nil] lastObject];
}

@end
