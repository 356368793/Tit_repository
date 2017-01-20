//
//  StatusFrame.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/3.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Status;
@class StatusPhotoesView;

#define kCellNameFont [UIFont systemFontOfSize:15]
#define kCellTimeFont [UIFont systemFontOfSize:12]
#define kCellSourceFont [UIFont systemFontOfSize:12]
#define kCellContentFont [UIFont systemFontOfSize:15]
#define kCellRetweetedContentFont [UIFont systemFontOfSize:14]

#define kCellBorder 10
#define kToolbarH 35
#define kCellMargin 15

@interface StatusFrame : NSObject
@property (strong, nonatomic) Status *status;
/** 原创微博整体Frame */
@property (assign, nonatomic) CGRect originalViewF;
/** 头像Frame */
@property (assign, nonatomic) CGRect iconViewF;
/** 会员图标Frame */
@property (assign, nonatomic) CGRect vipViewF;
/** 图片Frame */
@property (assign, nonatomic) CGRect photoesViewF;
/** 时间Frame */
@property (assign, nonatomic) CGRect timeLabelF;
/** 姓名Frame */
@property (assign, nonatomic) CGRect nameLabelF;
/** 来源Frame */
@property (assign, nonatomic) CGRect sourceLabelF;
/** 正文Frame */
@property (assign, nonatomic) CGRect contentLabelF;
/** cell高度 */
@property (assign, nonatomic) CGFloat cellHeight;
/** 转发微博整体Frame */
@property (assign, nonatomic) CGRect retweetedViewF;
/** 转发微博正文Frame */
@property (assign, nonatomic) CGRect retweetedContentLabelF;
/** 转发微博图片Frame */
@property (assign, nonatomic) CGRect retweetedPhotoesViewF;
/** 工具条Frame */
@property (assign, nonatomic) CGRect toolbarViewF;
@end
