//
//  ComposePhotoesView.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/8.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposePhotoesView : UIView
- (void)addPhoto:(UIImage *)photo;
@property (strong, nonatomic, readonly) NSMutableArray *photoes;

// 默认会自动生成setter和getter的声明和实现、_开头的成员变量
// 如果手动实现了setter和getter，那么就不会再生成settter、getter的实现、_开头的成员变量

//@property (nonatomic, strong, readonly) NSMutableArray *addedPhotos;
// 默认会自动生成getter的声明和实现、_开头的成员变量
// 如果手动实现了getter，那么就不会再生成getter的实现、_开头的成员变量


@end
