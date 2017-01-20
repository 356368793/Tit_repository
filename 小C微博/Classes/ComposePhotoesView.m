//
//  ComposePhotoesView.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/8.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "ComposePhotoesView.h"

@implementation ComposePhotoesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photoes = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoto:(UIImage *)photo
{
    UIImageView *photoesView = [[UIImageView alloc] init];
    photoesView.image = photo;
    [self.photoes addObject:photo];
    // 存储图片
    [self addSubview:photoesView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    int count = (int)self.subviews.count;
    int maxCols = 4;
    CGFloat photoMargin = 10;
    CGFloat photoWH = (self.width - (maxCols + 1) * photoMargin) / maxCols;
    // 设置图片尺寸
    for (int i = 0; i < (count<9?count:9); i++) {
        UIImageView *photoView = self.subviews[i];
        int col = i % maxCols;
        photoView.x = col * photoWH + (col + 1) * photoMargin;
        int row = i / maxCols;
        photoView.y = row * photoWH + (row + 1) * photoMargin;
        photoView.width = photoWH;
        photoView.height = photoWH;
        
        self.height = 4 * photoMargin + 3 * photoWH;
    }
}

@end
