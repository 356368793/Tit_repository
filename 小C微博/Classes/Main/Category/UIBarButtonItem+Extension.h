//
//  UIBarButtonItem+Extension.h
//  项目之微博
//
//  Created by 肖晨 on 15/7/29.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highLightedImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
