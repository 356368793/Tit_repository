//
//  EmotionPopView.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/9.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "EmotionPopView.h"
#import "Emotion.h"
#import "EmotionButton.h"

@interface EmotionPopView()
@property (weak, nonatomic) IBOutlet EmotionButton *emotionButton;

@end

@implementation EmotionPopView

+ (EmotionPopView *)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EmotionPopView" owner:nil options:nil] lastObject];
}

- (void)showFrom:(EmotionButton *)button
{
    if (button == nil) return;
    
    // 给popView传递数据
    self.emotionButton.emotion = button.emotion;
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 计算出被点击的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height; // 100
    self.centerX = CGRectGetMidX(btnFrame);
}

@end
