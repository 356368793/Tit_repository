//
//  ComposeToolbar.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/7.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "ComposeToolbar.h"

@interface ComposeToolbar()
@property (weak, nonatomic) UIButton *emotionButton;

@end

@implementation ComposeToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupBtnWithImage:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" buttonType:ComposeToolbarButtonTypeCamera];
        [self setupBtnWithImage:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" buttonType:ComposeToolbarButtonTypePicture];
        [self setupBtnWithImage:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" buttonType:ComposeToolbarButtonTypeMention];
        [self setupBtnWithImage:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" buttonType:ComposeToolbarButtonTypeTrend];
        self.emotionButton = [self setupBtnWithImage:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" buttonType:ComposeToolbarButtonTypeEmotion];
    }
    return self;
}

- (void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    
    // 默认的图片名
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    
    // 显示键盘图标
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    
    // 设置图片
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}

/**
 * 创建一个按钮
 */
- (UIButton *)setupBtnWithImage:(NSString *)image highImage:(NSString *)highImage buttonType:(ComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}

- (void)buttonDidClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButtonWithButtonType:)]) {
        [self.delegate composeToolbar:self didClickButtonWithButtonType:(ComposeToolbarButtonType)button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置所有按钮的frame
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (NSUInteger i = 0; i < count; i ++) {
        UIButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
}

@end
