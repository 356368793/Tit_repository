//
//  EmotionTool.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/12.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Emotion;

@interface EmotionTool : NSObject
+ (void)addRecentEmotion:(Emotion *)emotion;
+ (NSArray *)recentEmotions;
+ (NSArray *)defaultEmotions;
+ (NSArray *)lxhEmotions;
+ (NSArray *)emojiEmotions;

/**
 *  通过表情描述找到对应的表情
 */
+ (Emotion *)emotionWithChs:(NSString *)chs;

@end
