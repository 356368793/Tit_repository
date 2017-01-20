//
//  TitleButton.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/2.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "TitleButton.h"
#define kMargin 10

@implementation TitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    }
    return self;
}

// 在layoutSubviews设置完尺寸之后，再次修改尺寸(同时解决了初次开启时位置不对的问题)
- (void)setFrame:(CGRect)frame
{
    frame.size.width += kMargin;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置button的x
    self.titleLabel.x = self.imageView.x;
    // 设置title的x
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + kMargin;
    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}

@end
