//
//  StatusCell.h
//  项目之微博
//
//  Created by 肖晨 on 15/8/3.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusFrame;

@interface StatusCell : UITableViewCell

@property (strong, nonatomic) StatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
