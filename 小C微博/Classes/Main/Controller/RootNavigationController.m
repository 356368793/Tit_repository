//
//  ButtonStyle.m
//  项目之微博
//
//  Created by 肖晨 on 15/7/29.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "RootNavigationController.h"
#import <Foundation/Foundation.h>

@implementation RootNavigationController

+ (void)initialize
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 可用的情况下
    NSMutableDictionary *itemAttr = [NSMutableDictionary dictionary];
    itemAttr[NSForegroundColorAttributeName] = [UIColor colorWithRed:255/255.0 green:130/255.0 blue:0.0 alpha:1.0];
    itemAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:itemAttr forState:UIControlStateNormal];
    
    // 不可用的情况下
    NSMutableDictionary *disableItemAttr = [NSMutableDictionary dictionary];
    disableItemAttr[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
//    disableItemAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    disableItemAttr[NSFontAttributeName] = itemAttr[NSFontAttributeName];
    [item setTitleTextAttributes:disableItemAttr forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_back" highLightedImage:@"navigationbar_back_highlighted" target:self action:@selector(back)];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_more" highLightedImage:@"navigationbar_more_highlighted" target:self action:@selector(more)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

@end
