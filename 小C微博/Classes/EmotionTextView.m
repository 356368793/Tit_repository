//
//  EmotionTextView.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/9.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "EmotionTextView.h"
#import "Emotion.h"
#import "EmotionAttachment.h"

@implementation EmotionTextView

- (void)insertEmotion:(Emotion *)emotion
{
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        // 加载图片
        EmotionAttachment *attach = [[EmotionAttachment alloc] init];
        // 传递模型
        attach.emotion = emotion;
        // 设置图片尺寸
        CGFloat attachWH = self.font.lineHeight;
        attach.bounds = CGRectMake(0, -4, attachWH, attachWH);
        
        // 创建属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        
        
        // 插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
//            Log(@"%@", attributedText);
        }];
        
//        [self setNeedsDisplay];
    }
}

- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的文字
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        EmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) { // 图片
            [fullText appendString:attach.emotion.chs];
        } else { // 文字、Emoji
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
//    Log(@"%@", fullText);
    return fullText;
}

@end
