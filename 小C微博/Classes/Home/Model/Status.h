//
//  Status.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/2.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface Status : NSObject
/** 字符串型的微博ID */
@property (copy, nonatomic) NSString *idstr;
/** 微博信息内容 */
@property (copy, nonatomic) NSString *text;
/**	string	微博信息内容 -- 带有属性的(特殊文字会高亮显示\显示表情)*/
@property (copy, nonatomic) NSAttributedString *attributedText;
/** 微博作者的用户信息字段 */
@property (strong, nonatomic) User *user;
/** 微博创建时间 */
@property (copy, nonatomic) NSString *created_at;
/** 微博信息来源 */
@property (copy, nonatomic) NSString *source;
/** 微博图片数组 */
@property (strong, nonatomic) NSArray *pic_urls;
/** 转发微博 */
@property (strong, nonatomic) Status *retweeted_status;
/**	转发微博信息内容 -- 带有属性的(特殊文字会高亮显示\显示表情)*/
@property (copy, nonatomic) NSAttributedString *retweetedAttributedText;
/** 转发数 */
@property (assign, nonatomic) int reposts_count;
/** 评论数 */
@property (assign, nonatomic) int comments_count;
/** 表态数 */
@property (assign, nonatomic) int attitudes_count;

@end
