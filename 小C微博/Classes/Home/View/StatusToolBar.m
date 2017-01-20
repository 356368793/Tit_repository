//
//  StatusToolBar.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/5.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "StatusToolBar.h"
#import "Status.h"

@interface StatusToolBar()
/** 存放所有的分割线 */
@property (strong, nonatomic) NSMutableArray *dividers;
/** 存放所有的btn */
@property (strong, nonatomic) NSMutableArray *btns;
/** 转发按钮*/
@property (weak, nonatomic) UIButton *retweetBtn;
/** 评论按钮*/
@property (weak, nonatomic) UIButton *commentBtn;
/** 赞按钮*/
@property (weak, nonatomic) UIButton *attitudeBtn;

@end

@implementation StatusToolBar

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [[NSMutableArray alloc] init];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        _dividers = [[NSMutableArray alloc] init];
    }
    return _dividers;
}

+ (instancetype)toolbar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        // 添加按钮
        self.retweetBtn = [self setupBtnWithTitle:@"转发" image:[UIImage imageNamed:@"timeline_icon_retweet"]];
        self.commentBtn = [self setupBtnWithTitle:@"评论" image:[UIImage imageNamed:@"timeline_icon_comment"]];
        self.attitudeBtn = [self setupBtnWithTitle:@"赞" image:[UIImage imageNamed:@"timeline_icon_unlike"]];
        
        //添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}

- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

- (UIButton *)setupBtnWithTitle:(NSString *)title image:(UIImage *)image
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_line_highlighted"] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int btnCount = (int)self.btns.count;
    CGFloat btnW = self.bounds.size.width / btnCount;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = self.height;
    }
    
    int dividerCount = (int)self.dividers.count;
    for (int i = 0; i <dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = self.height;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
    }
}

- (void)setStatus:(Status *)status
{
    _status = status;
//    status.comments_count = 216989;
//    status.reposts_count = 10810;
//    status.attitudes_count = 9860;
    
    // 转发
    [self setupBtnTitleWithCount:status.reposts_count btn:self.retweetBtn title:@"转发"];
    // 评论
    [self setupBtnTitleWithCount:status.comments_count btn:self.commentBtn title:@"评论"];
    // 赞
    [self setupBtnTitleWithCount:status.attitudes_count btn:self.attitudeBtn title:@"赞"];
}

- (void)setupBtnTitleWithCount:(int)count btn:(UIButton *)btn title:(NSString *)title
{
    if (count) { // 数字不为0
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%d", count];
        } else {
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", wan];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
    }
}


@end
