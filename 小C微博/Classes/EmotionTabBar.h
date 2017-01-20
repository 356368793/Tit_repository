//
//  EmotionTabBar.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/8.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EmotionTabBarButtonTypeRecent, // 最近
    EmotionTabBarButtonTypeDefault, // 默认
    EmotionTabBarButtonTypeEmoji, // Emoji
    EmotionTabBarButtonTypeLxh // 浪小花
} EmotionTabBarButtonType;

@class EmotionTabBar;

@protocol EmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectButton:(EmotionTabBarButtonType)buttonType;

@end

@interface EmotionTabBar : UIView
@property (weak, nonatomic) id<EmotionTabBarDelegate> delegate;

@end
