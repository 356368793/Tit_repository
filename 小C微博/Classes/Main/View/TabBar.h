//
//  TabBar.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/1.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;

@protocol TabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickPlusButton:(TabBar *)tabBar;

@end

@interface TabBar : UITabBar
@property (weak, nonatomic) id<TabBarDelegate> delegate;

@end
