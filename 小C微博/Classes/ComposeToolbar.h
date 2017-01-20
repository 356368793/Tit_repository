//
//  ComposeToolbar.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/7.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComposeToolbar;

typedef enum {
    ComposeToolbarButtonTypeCamera, // 拍照
    ComposeToolbarButtonTypePicture, // 相册
    ComposeToolbarButtonTypeMention, // @
    ComposeToolbarButtonTypeTrend, // #
    ComposeToolbarButtonTypeEmotion // 表情
} ComposeToolbarButtonType;
@protocol ComposeToolbarDelegate <NSObject>

- (void)composeToolbar:(ComposeToolbar *)toolbar didClickButtonWithButtonType:(ComposeToolbarButtonType)buttonType;

@end

@interface ComposeToolbar : UIView
@property (weak, nonatomic) id<ComposeToolbarDelegate> delegate;
/** 是否要显示键盘按钮  */
@property (assign, nonatomic) BOOL showKeyboardButton;
@end
