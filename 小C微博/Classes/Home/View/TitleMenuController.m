//
//  TableViewController.m
//  项目之微博
//
//  Created by 肖晨 on 15/7/31.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "TitleMenuController.h"

@implementation TitleMenuController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Friends";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"White";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Ruby";
    }
    
    return cell;
}

@end
