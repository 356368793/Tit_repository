//
//  Special.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/13.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Special : NSObject
/** 这段特殊文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段特殊文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 这段特殊文字的矩形框(要求数组里面存放CGRect) */
@property (nonatomic, strong) NSArray *rects;

@end
