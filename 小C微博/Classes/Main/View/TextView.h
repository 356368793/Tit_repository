//
//  TextView.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/7.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UITextView

@property (copy, nonatomic) NSString *placeholder;
@property (strong, nonatomic) UIColor *placeholderColor;

@end
