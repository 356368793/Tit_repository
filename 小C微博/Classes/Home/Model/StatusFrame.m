//
//  StatusFrame.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/3.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "StatusFrame.h"
#import "Status.h"
#import "User.h"
#import "StatusPhotoesView.h"

@implementation StatusFrame



- (void)setStatus:(Status *)status
{
    _status = status;
    User *user = status.user;
    
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 头像Frame */
    CGFloat iconWH = 40;
    self.iconViewF = CGRectMake(kCellBorder, kCellBorder, iconWH, iconWH);
    
    /** 姓名Frame */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + kCellBorder;
    CGFloat nameY = kCellBorder;
    CGSize nameSize = [user.name sizeWithFont:kCellNameFont];
//    self.nameLabelF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标Frame */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + kCellBorder;
        CGFloat vipY = kCellBorder;
        CGFloat vipW = 14;
        CGFloat vipH = nameSize.height;
        self.vipViewF = (CGRect){{vipX, vipY},{vipW, vipH}};
    }
    
    /** 时间Frame */
    CGFloat timeX = nameX;
    CGSize timeSize = [status.created_at sizeWithFont:kCellTimeFont];
//    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + kCellBorder;
    CGFloat timeY = CGRectGetMaxY(self.iconViewF) - timeSize.height;
    self.timeLabelF = (CGRect){{timeX, timeY},timeSize};
    
    /** 来源Frame */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + kCellBorder;
    CGSize sourceSize = [status.source sizeWithFont:kCellSourceFont];
    CGFloat sourceY = CGRectGetMaxY(self.iconViewF) - sourceSize.height;
    self.sourceLabelF = (CGRect){{sourceX, sourceY},sourceSize};
    
    /** 正文Frame */
    CGFloat contentX = kCellBorder;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + kCellBorder;
    CGFloat maxW = cellW - 2 * kCellBorder;
    CGSize contentSize = [status.attributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    
    CGFloat originalH = 0;
    /** 图片Frame */
    if (status.pic_urls.count) {
        CGFloat photoesX = kCellBorder;
        CGFloat photoesY = CGRectGetMaxY(self.contentLabelF) + kCellBorder;
        CGSize photoesSize = [StatusPhotoesView sizeWithCount:(int)status.pic_urls.count];
        self.photoesViewF = CGRectMake(photoesX, photoesY, photoesSize.width, photoesSize.height);
        
        originalH = CGRectGetMaxY(self.photoesViewF) + kCellBorder;
    } else {
        originalH = CGRectGetMaxY(self.contentLabelF) + kCellBorder;
    }
    
    /** 原创微博整体Frame */
    CGFloat originalX = 0;
    CGFloat originalY = kCellMargin;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    
    /** 转发微博 */
    if (status.retweeted_status) {
        Status *retweeted_status = status.retweeted_status;
//        User *retweeted_status_user = retweeted_status.user;
        /** 转发微博正文Frame */
        CGFloat retweetedContentX = kCellBorder;
        CGFloat retweetedContentY = kCellBorder;
        CGSize retweetedContentSize = [status.retweetedAttributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.retweetedContentLabelF = (CGRect){{retweetedContentX, retweetedContentY}, retweetedContentSize};
        
        CGFloat retweetedH = 0;
        /** 转发微博图片Frame */
        if (retweeted_status.pic_urls.count) {
            CGFloat retweetedPhotoesX = kCellBorder;
            CGFloat retweetedPhotoesY = CGRectGetMaxY(self.retweetedContentLabelF) + kCellBorder;
            CGSize photoesSize = [StatusPhotoesView sizeWithCount:(int)retweeted_status.pic_urls.count];
            self.retweetedPhotoesViewF = CGRectMake(retweetedPhotoesX, retweetedPhotoesY, photoesSize.width, photoesSize.height);
            
            retweetedH = CGRectGetMaxY(self.retweetedPhotoesViewF) + kCellBorder;
        } else {
            retweetedH = CGRectGetMaxY(self.retweetedContentLabelF) + kCellBorder;
        }
        
        /** 转发微博整体Frame */
        CGFloat retweetedX = 0;
        CGFloat retweetedY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetedW = cellW;
        self.retweetedViewF = CGRectMake(retweetedX, retweetedY, retweetedW, retweetedH);
        
        /** 工具条 */
        self.toolbarViewF = CGRectMake(0, CGRectGetMaxY(self.retweetedViewF), cellW, kToolbarH);
    } else {
        /** 工具条 */
        self.toolbarViewF = CGRectMake(0, CGRectGetMaxY(self.originalViewF), cellW, kToolbarH);
    }
    /** cell高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarViewF);
}

@end
