//
//  DropdownMenu.m
//  项目之微博
//
//  Created by 肖晨 on 15/7/31.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "DropdownMenu.h"

@interface DropdownMenu()
@property (strong, nonatomic) UIImageView *containerView;

@end

@implementation DropdownMenu

- (UIImageView *)containerView
{
    if (_containerView == nil) {
        // 添加一个灰色图片控件
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"popover_background"];
        _containerView.width = 200;
        _containerView.height = 300;
        _containerView.userInteractionEnabled = YES;
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    // 根据容器尺寸 设置内容宽高
    _content.x = 8;
    _content.y = 15;
//    _content.width = self.containerView.bounds.size.width - _content.x *2;
//    _content.height = CGRectGetMaxY(self.containerView.frame) - 25;
    self.containerView.height = CGRectGetMaxY(_content.frame) + 10;
    self.containerView.width = CGRectGetMaxX(_content.frame) + 8;
    
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    self.content = _contentController.view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

+ (instancetype)menu
{
    return [[self alloc] init];
}

- (void)showFrom:(UIView *)from
{
    //  获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:self];
    
    self.frame = window.bounds;
    
    //转换坐标系
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    self.containerView.centerX = CGRectGetMidX(newFrame);
//    self.containerView.y = 50;
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (void)dismiss
{
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

@end
