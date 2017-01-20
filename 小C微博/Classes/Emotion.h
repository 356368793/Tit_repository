//
//  Emotion.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/8.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotion : NSObject
/** 表情模型名称 */
@property (copy, nonatomic) NSString *chs;
/** 表情图片名称 */
@property (copy, nonatomic) NSString *png;
/** Emoji表情模型16进制编码 */
@property (copy, nonatomic) NSString *code;

@end
