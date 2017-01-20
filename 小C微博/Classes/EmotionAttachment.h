//
//  EmotionAttachment.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/9.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;

@interface EmotionAttachment : NSTextAttachment
@property (strong, nonatomic) Emotion *emotion;
@end
