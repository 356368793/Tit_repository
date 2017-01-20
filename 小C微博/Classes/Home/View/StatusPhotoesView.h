//
//  StatusPhotoesView.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/6.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//  cell上面的配图相册

#import <UIKit/UIKit.h>

@interface StatusPhotoesView : UIView
@property (strong, nonatomic) NSArray *photoes;

+ (CGSize)sizeWithCount:(int)count;
@end
