//
//  TabBar.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/1.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "TabBar.h"

@interface TabBar()

@property (strong, nonatomic)UIButton *plusBtn;

@end


@implementation TabBar
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _plusBtn = [[UIButton alloc] init];
        [_plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [_plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        _plusBtn.size = _plusBtn.currentBackgroundImage.size;
        _plusBtn.centerX = self.width * 0.5;
        _plusBtn.centerY = self.height * 0.5;
        [self addSubview:_plusBtn];
        [_plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)plusBtnClick
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    
    
    CGFloat tabbarButtonW = self.width * 0.2;
    CGFloat tabbarButtonIndex = 0;
    NSUInteger count = self.subviews.count;
    
//    for (UIView *child in self.subviews) {
//        <#statements#>
//    }
    for (int i = 0; i < count; i++) {
        UIView *child = self.subviews[i];
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.width = tabbarButtonW;
            child.x = tabbarButtonW *tabbarButtonIndex;
            
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

@end
