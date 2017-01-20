//
//  StatusPhotoesView.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/6.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "StatusPhotoesView.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "StatusPhotoView.h"


#define kStatusPhotoesWH 70
#define kStatusPhotoesMargin 10
#define kStatusPhotoesMaxCol(count) ((count == 4)?2:3)

@implementation StatusPhotoesView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)setPhotoes:(NSArray *)photoes
{
    _photoes = photoes;
    
    int photoesCount = (int)self.photoes.count;
    // 如果图片View不足，则创建
    while (self.subviews.count < photoesCount) {
        StatusPhotoView *photoView = [[StatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    for (int i = 0; i < self.subviews.count; i++){
        StatusPhotoView *photoView = self.subviews[i];
        
        if (i < photoesCount) {
            photoView.hidden = NO;
            photoView.photo = photoes[i];
        } else {
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    int photoesCount = (int)self.photoes.count;
    int maxCols = kStatusPhotoesMaxCol(photoesCount);
    // 设置图片尺寸
    for (int i = 0; i < photoesCount; i++) {
        StatusPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCols;
        photoView.x = col * (kStatusPhotoesWH + kStatusPhotoesMargin);
        int row = i / maxCols;
        photoView.y = row * (kStatusPhotoesWH + kStatusPhotoesMargin);
        photoView.width = kStatusPhotoesWH;
        photoView.height = kStatusPhotoesWH;
    }
}

+ (CGSize)sizeWithCount:(int)count
{
    int maxCols = kStatusPhotoesMaxCol(count);
    // 行
    int rows = (count - 1) / maxCols + 1;
    // 列
    int cols = (count > (maxCols - 1)) ? maxCols : count;
    
    CGFloat photoesW = cols * kStatusPhotoesWH + (cols - 1) * kStatusPhotoesMargin;
    CGFloat photoesH = rows * kStatusPhotoesWH + (rows - 1) * kStatusPhotoesMargin;
    
    return CGSizeMake(photoesW, photoesH);
}

@end
