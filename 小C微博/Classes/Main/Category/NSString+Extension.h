//
//  NSString+Extension.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/6.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font;

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  计算当前文件\文件夹的内容大小
 */
- (NSInteger)fileSize;
@end
