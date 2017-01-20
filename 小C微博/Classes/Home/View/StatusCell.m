//
//  StatusCell.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/3.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "StatusCell.h"
#import "StatusFrame.h"
#import "Status.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "StatusToolBar.h"
#import "StatusPhotoesView.h"
#import "IconView.h"
#import "StatusTextView.h"

@interface StatusCell()
/** 原创微博 */
/** 原创微博整体 */
@property (weak, nonatomic) UIView *originalView;
/** 头像 */
@property (weak, nonatomic) IconView *iconView;
/** 会员图标 */
@property (weak, nonatomic) UIImageView *vipView;
/** 图片 */
@property (weak, nonatomic) StatusPhotoesView *photoesView;
/** 时间 */
@property (weak, nonatomic) UILabel *timeLabel;
/** 姓名 */
@property (weak, nonatomic) UILabel *nameLabel;
/** 来源 */
@property (weak, nonatomic) UILabel *sourceLabel;
/** 正文 */
@property (weak, nonatomic) StatusTextView *contentLabel;
/** 转发微博整体 */
@property (weak, nonatomic) UIView *retweetedView;
/** 转发微博正文+昵称 */
@property (weak, nonatomic) StatusTextView *retweetedContentLabel;
/** 转发微博配图 */
@property (weak, nonatomic) StatusPhotoesView *retweetedPhotoesView;
/** 工具条 */
@property (weak, nonatomic) StatusToolBar *toolbarView;


@end

@implementation StatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"statuses";
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /** 创建原创微博 */
        [self setupOriginal];
        /** 创建转发微博 */
        [self setupRetweeted];
        /** 创建Toolbar */
        [self setupToolbar];
    }
    return self;
}

/** 创建Toolbar */
- (void)setupToolbar
{
    /** Toolbar */
    StatusToolBar *toolbarView = [StatusToolBar toolbar];
    [self.contentView addSubview:toolbarView];
    self.toolbarView = toolbarView;
}

/** 创建转发微博 */
- (void)setupRetweeted
{
    /** 转发微博整体 */
    UIView *retweetedView = [[UIView alloc] init];
    retweetedView.backgroundColor = Color(247, 247, 247);
    [self.contentView addSubview:retweetedView];
    self.retweetedView = retweetedView;
    
    /** 转发微博配图 */
    StatusPhotoesView *retweetedPhotoesView = [[StatusPhotoesView alloc] init];
    [retweetedView addSubview:retweetedPhotoesView];
    self.retweetedPhotoesView = retweetedPhotoesView;
    
    /** 转发微博正文+昵称 */
    StatusTextView *retweetedContentLabel = [[StatusTextView alloc] init];
    [retweetedView addSubview:retweetedContentLabel];
    self.retweetedContentLabel = retweetedContentLabel;
    
}

/** 创建原创微博 */
- (void)setupOriginal
{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 原创微博头像 */
    IconView *iconView = [[IconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 原创微博会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    [originalView addSubview:vipView];
    vipView.contentMode = UIViewContentModeCenter;
    self.vipView = vipView;
    
    /** 原创微博图片 */
    StatusPhotoesView *photoesView = [[StatusPhotoesView alloc] init];
    [originalView addSubview:photoesView];
    self.photoesView = photoesView;
    
    /** 原创微博时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    [originalView addSubview:timeLabel];
    timeLabel.font = kCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    self.timeLabel = timeLabel;
    
    /** 原创微博姓名 */
    UILabel *nameLabel = [[UILabel alloc] init];
    [originalView addSubview:nameLabel];
    nameLabel.font = kCellNameFont;
    self.nameLabel = nameLabel;
    
    /** 原创微博来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = kCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 原创微博正文 */
    StatusTextView *contentLabel = [[StatusTextView alloc] init];
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)setStatusFrame:(StatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    Status *status = statusFrame.status;
    User *user = status.user;
    
    /** 原创微博整体Frame */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像Frame */
    self.iconView.frame = statusFrame.iconViewF;
    self.iconView.user = user;
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    /** 图片Frame */
    if (status.pic_urls.count){
        self.photoesView.frame = statusFrame.photoesViewF;
        self.photoesView.photoes = status.pic_urls;
//        Photo *photoes = [status.pic_urls firstObject];
//        [self.photoesView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
//        [self.photoesView sizeToFit];
        self.photoesView.hidden = NO;
    } else {
        self.photoesView.hidden = YES;
    }
    
    /** 姓名Frame */
    self.nameLabel.frame = statusFrame.nameLabelF;
    self.nameLabel.text = user.name;
    
    /** 时间Frame */
    self.timeLabel.text = status.created_at;
    CGFloat timeX = statusFrame.nameLabelF.origin.x;
    CGSize timeSize = [status.created_at sizeWithFont:kCellTimeFont];
    CGFloat timeY = CGRectGetMaxY(statusFrame.iconViewF) - timeSize.height;
    self.timeLabel.frame = (CGRect){{timeX, timeY},timeSize};
    
    /** 来源Frame */
    self.sourceLabel.text = status.source;
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + kCellBorder;
    CGSize sourceSize = [status.source sizeWithFont:kCellSourceFont];
    CGFloat sourceY = CGRectGetMaxY(statusFrame.iconViewF) - sourceSize.height;
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY},sourceSize};
    
    /** 正文Frame */
    self.contentLabel.frame = statusFrame.contentLabelF;
    self.contentLabel.attributedText = status.attributedText;
    
    /** 转发微博Frame */
    if (status.retweeted_status) {
        Status *retweeted_status = status.retweeted_status;
        self.retweetedView.hidden = NO;
        
        self.retweetedView.frame = statusFrame.retweetedViewF;
        
        /** 转发微博正文Frame */
        self.retweetedContentLabel.frame = statusFrame.retweetedContentLabelF;
        self.retweetedContentLabel.attributedText = status.retweetedAttributedText;
        
        /** 转发微博图片Frame */
        if (retweeted_status.pic_urls.count){
            self.retweetedPhotoesView.frame = statusFrame.retweetedPhotoesViewF;
            self.retweetedPhotoesView.photoes = retweeted_status.pic_urls;
//            Photo *retweetedPhoto = [retweeted_status.pic_urls firstObject];
//            [self.retweetedPhotoView sd_setImageWithURL:[NSURL URLWithString:retweetedPhoto.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            self.retweetedPhotoesView.hidden = NO;
        } else {
            self.retweetedPhotoesView.hidden = YES;
        }
    } else {
        self.retweetedView.hidden = YES;
    }
    
    /** Toolbar Frame */
    self.toolbarView.frame = statusFrame.toolbarViewF;
    self.toolbarView.status = status;
}


@end
