//
//  EmotionKeyboard.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/8.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "EmotionListView.h"
#import "EmotionTabBar.h"
#import "Emotion.h"
#import "MJExtension.h"
#import "EmotionTool.h"

@interface EmotionKeyboard()<EmotionTabBarDelegate>
/** 保存正在显示listView */
@property (nonatomic, weak) EmotionListView *showingListView;
/** 最近键盘表情 */
@property (strong, nonatomic) EmotionListView *recentListView;
/** 默认键盘表情 */
@property (strong, nonatomic) EmotionListView *defaultListView;
/** Emoji键盘表情 */
@property (strong, nonatomic) EmotionListView *emojiListView;
/** 浪小花键盘表情 */
@property (strong, nonatomic) EmotionListView *lxhListView;
/** tabBar */
@property (weak, nonatomic) EmotionTabBar *tabBar;

@end

@implementation EmotionKeyboard

#pragma mark - 懒加载
- (EmotionListView *)recentListView
{
    if (_recentListView == nil) {
        self.recentListView = [[EmotionListView alloc] init];
        // 加载沙盒中的数据
        self.recentListView.emotions = [EmotionTool recentEmotions];
    }
    return _recentListView;
}

- (EmotionListView *)defaultListView
{
    if (_defaultListView == nil) {
        _defaultListView = [[EmotionListView alloc] init];
        self.defaultListView.emotions = [EmotionTool defaultEmotions];
    }
    return _defaultListView;
}

- (EmotionListView *)emojiListView
{
    if (_emojiListView == nil) {
        _emojiListView = [[EmotionListView alloc] init];
        self.emojiListView.emotions = [EmotionTool emojiEmotions];
    }
    return _emojiListView;
}

- (EmotionListView *)lxhListView
{
    if (_lxhListView == nil) {
        _lxhListView = [[EmotionListView alloc] init];
        self.lxhListView.emotions = [EmotionTool lxhEmotions];
    }
    return _lxhListView;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // tabbar
        EmotionTabBar *tabBar = [[EmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
        // 表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:EmotionDidSelectNotification object:nil];
    }
    return self;
}

- (void)emotionDidSelect
{
    self.recentListView.emotions = [EmotionTool recentEmotions];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - EmotionTabBarDelegate
- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectButton:(EmotionTabBarButtonType)buttonType
{
    // 移除正在显示的listView控件
    [self.showingListView removeFromSuperview];
    
    // 根据按钮类型，切换键盘上面的listview
    switch (buttonType) {
        case EmotionTabBarButtonTypeRecent: { // 最近
            // 加载沙盒中的数据
            // self.recentListView.emotions = [EmotionTool recentEmotions];
            [self addSubview:self.recentListView];
            break;
        }
            
        case EmotionTabBarButtonTypeDefault: { // 默认
            [self addSubview:self.defaultListView];
            break;
        }
            
        case EmotionTabBarButtonTypeEmoji: { // Emoji
            [self addSubview:self.emojiListView];
            break;
        }
            
        case EmotionTabBarButtonTypeLxh: { // Lxh
            [self addSubview:self.lxhListView];
            break;
        }
    }
    
    // 设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    
    // 设置frame
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // tabbar
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    // 表情内容
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
    self.showingListView.x = 0;
    self.showingListView.y = 0;
}

@end
