//
//  StatusTextView.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/13.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusTextView : UITextView

/** 所有的特殊字符串(里面存放着Special) */
@property (nonatomic, strong) NSArray *specials;

@end
