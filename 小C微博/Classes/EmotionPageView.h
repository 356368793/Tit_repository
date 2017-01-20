//
//  EmotionPageView.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/9.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//  每一页的表情

#import <UIKit/UIKit.h>
// 每页表情列数
#define EmotionPageMaxCols 7
// 每页表情行数
#define EmotionPageMaxRows 3
// 每页表情数量
#define EmotionPageSize (EmotionPageMaxCols * EmotionPageMaxRows - 1)

@interface EmotionPageView : UIView
/** 这一页显示的表情（里面都是Emotion模型） */
@property (strong, nonatomic) NSArray *emotions;
@end
