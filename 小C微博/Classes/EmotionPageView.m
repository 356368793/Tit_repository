//
//  EmotionPageView.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/9.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "EmotionPageView.h"
#import "Emotion.h"
#import "EmotionPopView.h"
#import "EmotionButton.h"
#import "EmotionTool.h"

@interface EmotionPageView()
/** 点击表情后弹出的放大镜 */
@property (weak, nonatomic) EmotionPopView *popView;
/** 删除按钮 */
@property (weak, nonatomic) UIButton *deleteButton;
@end

@implementation EmotionPageView

- (EmotionPopView *)popView
{
    if (_popView == nil) {
        _popView = [EmotionPopView popView];
    }
    return _popView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [self addSubview:deleteBtn];
        self.deleteButton = deleteBtn;
        
        // 2.添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}
/**
 *  根据手指位置所在的表情按钮
 */
- (EmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i<count; i++) {
        EmotionButton *btn = self.subviews[i + 1];
        if (CGRectContainsPoint(btn.frame, location)) {
            
            // 已经找到手指所在的表情按钮了，就没必要再往下遍历
            return btn;
        }
    }
    return nil;
}

/**
 *  在这个方法中处理长按手势
 */
- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    // 获得手指所在的位置\所在的表情按钮
    EmotionButton *btn = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: // 手指已经不再触摸pageView
            // 移除popView
            [self.popView removeFromSuperview];
            
            // 如果手指还在表情按钮上
            if (btn) {
                // 发出通知
                [self selectEmotion:btn.emotion];
            }
            break;
            
        case UIGestureRecognizerStateBegan: // 手势开始（刚检测到长按）
        case UIGestureRecognizerStateChanged: { // 手势改变（手指的位置改变）
            [self.popView showFrom:btn];
            break;
        }
            
        default:
            break;
    }
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    for (int i = 0; i < emotions.count; i++) {
        EmotionButton *btn = [[EmotionButton alloc] init];
        [self addSubview:btn];
        
        // 设置表情数据
        btn.emotion = self.emotions[i];
        
        // 监听按钮点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)deleteClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EmotionDidDeleteNotification object:nil];
}

- (void)btnClick:(EmotionButton *)button
{
    // 显示popView
    [self.popView showFrom:button];
    
    // 等会让popView自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 发出通知
    [self selectEmotion:button.emotion];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat inset = 10;
    CGFloat btnW = (self.width - 2 * inset) / EmotionPageMaxCols;
    CGFloat btnH = (self.height - inset) / EmotionPageMaxRows;
    NSUInteger count = self.emotions.count;
    
    for (int i = 0; i < count; i++) {
        EmotionButton *btn = self.subviews[i+1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = (i % EmotionPageMaxCols) * btnW + inset;
        btn.y = (i / EmotionPageMaxCols) * btnH + inset;
    }
    
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.x = self.width - inset - btnW;
    self.deleteButton.y = self.height - btnH;
}

/**
 *  选中某个表情，发出通知
 */
- (void)selectEmotion:(Emotion *)emotion
{
    // 将这个表情存进沙盒
    [EmotionTool addRecentEmotion:emotion];
    
    // 发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[SelectEmotionKey] = emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:EmotionDidSelectNotification object:nil userInfo:userInfo];
}

@end
