//
//  DropdownMenu.h
//  项目之微博
//
//  Created by 肖晨 on 15/7/31.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownMenu;
@protocol  DropdownMenuDelegate <NSObject>

@optional
- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu;
- (void)dropdownMenuDidShow:(DropdownMenu *)menu;

@end

@interface DropdownMenu : UIView
+ (instancetype)menu;
- (void)showFrom:(UIView *)from;
- (void)dismiss;
@property (weak, nonatomic) id<DropdownMenuDelegate> delegate;

@property (strong, nonatomic) UIView *content;
@property (strong, nonatomic) UIViewController *contentController;

@end
