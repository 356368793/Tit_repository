//
//  TextPart.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/13.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextPart : NSObject

// 字段正文
@property (copy, nonatomic) NSString *text;
// 字段范围
@property (assign, nonatomic) NSRange range;
// 字段是否为特殊字符
@property (assign, nonatomic, getter=isSpecial) BOOL special;
// 字段是否为表情字符
@property (assign, nonatomic, getter=isEmotion) BOOL emotion;

@end
