//
//  EmotionTabBar.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/8.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "EmotionTabBar.h"
#import "EmotionTabBarButton.h"

@interface EmotionTabBar()
@property (weak, nonatomic) EmotionTabBarButton *selectedBtn;
@end

@implementation EmotionTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButtonWithTitle:@"最近" buttonType:EmotionTabBarButtonTypeRecent];
        [self setupButtonWithTitle:@"默认" buttonType:EmotionTabBarButtonTypeDefault];
//        [self btnClick:[self setupButtonWithTitle:@"默认" buttonType:EmotionTabBarButtonTypeDefault]];
        [self setupButtonWithTitle:@"Emoji" buttonType:EmotionTabBarButtonTypeEmoji];
        [self setupButtonWithTitle:@"浪小花" buttonType:EmotionTabBarButtonTypeLxh];
    }
    return self;
}

/**
 *  创建一个按钮
 */
- (EmotionTabBarButton *)setupButtonWithTitle:(NSString *)title buttonType:(EmotionTabBarButtonType)buttonType
{
    // 创建按钮
    EmotionTabBarButton *btn = [[EmotionTabBarButton alloc] init];
    btn.tag = buttonType;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    // 设置背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectedImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 0) {
        image = @"compose_emotion_table_left_normal";
        selectedImage = @"compose_emotion_table_left_selected";
    } else if (self.subviews.count == 3) {
        image = @"compose_emotion_table_right_normal";
        selectedImage = @"compose_emotion_table_right_selected";
    }
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateDisabled];
    
    return btn;
}

/**
 *  按钮点击
 */
- (void)btnClick:(EmotionTabBarButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:(EmotionTabBarButtonType)btn.tag];
    }
}

- (void)setDelegate:(id<EmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    
    // 选中“默认”按钮
    [self btnClick:(EmotionTabBarButton *)[self viewWithTag:EmotionTabBarButtonTypeDefault]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int btnCount = (int)self.subviews.count;
    CGFloat btnW = self.bounds.size.width / btnCount;
    for (int i = 0; i<btnCount; i++) {
        EmotionTabBarButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = self.height;
    }
}

@end
