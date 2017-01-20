//
//  MainViewController.m
//  项目之微博
//
//  Created by 肖晨 on 15/7/29.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageCenterViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "RootNavigationController.h"
#import "TabBar.h"
#import "ComposeViewController.h"

@interface MainViewController ()<TabBarDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置子控制器
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    MessageCenterViewController *messageCenter = [[MessageCenterViewController alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
//    [self addChildViewController:[[UIViewController alloc] init]];
    
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    TabBar *tabBar = [[TabBar alloc] init];
//    tabBar.delegate = self;
    // 修改系统自带的tabBar
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
//    self.viewControllers = @[ home, messageCenter, discover, profile];
}

/**
 *  点击加号按钮，推出一个新的navigationController。
 */
- (void)tabBarDidClickPlusButton:(TabBar *)tabBar
{
    ComposeViewController *compose = [[ComposeViewController alloc] init];
    
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:compose];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title; // 同时设置tabBar和navigationBar的文字
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]
                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    NSMutableDictionary* textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = Color(123, 123, 123);
    NSMutableDictionary* selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs
                                      forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs
                                      forState:UIControlStateSelected];
    
    // 包装navigationcontroller
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
}

@end
