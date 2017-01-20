//
//  Status.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/2.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "Status.h"
#import "MJExtension.h"
#import "Photo.h"
#import "RegexKitLite.h"
#import "User.h"
#import "TextPart.h"
#import "EmotionTool.h"
#import "Emotion.h"
#import "Special.h"

@implementation Status

+ (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls":[Photo class]};
}

- (NSAttributedString *)attributedTextWithText:(NSString *)text
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
    
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    // 按照规则 抽取特殊字符串
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[TextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    // 按照规则，取出除特殊字符串以外的普通字符串
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[TextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 按照location进行排序
    [parts sortUsingComparator:^NSComparisonResult(TextPart *part1, TextPart *part2) {
        if (part1.range.location > part2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    // 拼接字符串
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *specials = [NSMutableArray array];
    for (TextPart *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *subStr = nil;
        if (part.isEmotion) { // 字段为表情字符
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            NSString *name = [EmotionTool emotionWithChs:part.text].png;
//            NSString *name = [EmotionTool emotionWithChs:part.text].png;
            if (name) { // 能找到对应的图片
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                subStr = [NSAttributedString attributedStringWithAttachment:attch];
            } else { // 表情图片不存在
                subStr = [[NSAttributedString alloc] initWithString:part.text];
            }
        } else if (part.isSpecial) { // 字段为除表情外的特殊字符
            subStr = [[NSAttributedString alloc] initWithString:part.text attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
            // 创建特殊对象
            Special *special = [[Special alloc] init];
            special.text = part.text;
            NSUInteger loc = attributeString.length;
            NSUInteger len = part.text.length;
            special.range = NSMakeRange(loc, len);
            [specials addObject:special];
        } else { // 字段为普通字符
            subStr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributeString appendAttributedString:subStr];
    }
    
    // 设置属性字符串的字体
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributeString.length)];
//    [attributeString addAttributes:@{NSFontAttributeName : font} range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    
    return attributeString;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    // 利用text生成attributedText
    self.attributedText = [self attributedTextWithText:text];
}

- (void)setRetweeted_status:(Status *)retweeted_status
{
    _retweeted_status = retweeted_status;
    
    NSString *retweetedContent = [NSString stringWithFormat:@"@%@ : %@",retweeted_status.user.name, retweeted_status.text];
    self.retweetedAttributedText = [self attributedTextWithText:retweetedContent];
}

- (NSString *)created_at
{
    // dateFormatter : Wed Aug 05 22:27:54 +0800 2015
    // dateFormatter : EEE MMM dd HH:mm:ss Z yyyy
    // 日期格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    // 本地化日期
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    // 微博创建日期
    NSDate *createDate = [fmt dateFromString:_created_at];
//    NSDate *createDate = [fmt dateFromString:@"Wed Aug 06 00:00:54 +0800 2015"];
    // 当前时间
    NSDate *now = [NSDate date];
//    NSDate *now = [fmt dateFromString:@"Wed Aug 06 00:01:54 +0800 2015"];
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 计算两个日期的差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
//    NSDateComponents *createDateCmps = [calendar components:unit fromDate:createDate];
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:now];
    // 伪代码
    if ([createDate isThisYear]) { // 今年
        if ([createDate isToday]) { // 今天
            if ([createDate isYesterday]) { // 昨天
                fmt.dateFormat = @"昨天 HH:mm";
                return [fmt stringFromDate:createDate];
            } else if (cmps.minute >= 1) { // 一分钟~一小时内
                NSString *dateStr = [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
                return dateStr;
            } else { // 一分钟内
                return @"刚刚";
            }
        } else if (cmps.hour >= 1) { // 一小时外
            NSString *dateStr = [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            return dateStr;
        } else { // 其他天份
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 其他年份
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

- (void)setSource:(NSString *)source
{
    if (source.length > 0) {
        // <a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
        NSRange range;
        range.location = [source rangeOfString:@">"].location + 1;
        range.length = [source rangeOfString:@"</"].location - range.location;
        NSString *str = [NSString stringWithFormat:@"from %@", [source substringWithRange:range]];
        _source = str;
    } else {
        _source = source;
    }
}

@end
