//
//  StatusToolBar.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/5.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;

@interface StatusToolBar : UIView

@property (strong, nonatomic)  Status *status;

+ (instancetype)toolbar;

@end
