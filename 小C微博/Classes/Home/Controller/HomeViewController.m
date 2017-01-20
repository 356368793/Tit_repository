//
//  HomeViewController.m
//  项目之微博
//
//  Created by 肖晨 on 15/7/29.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "HomeViewController.h"
#import "DropdownMenu.h"
#import "TitleMenuController.h"
#import "HTTPTool.h"
#import "AccountTool.h"
#import "TitleButton.h"
#import "UIImageView+WebCache.h"
#import "Status.h"
#import "User.h"
#import "MJExtension.h"
#import "LoadMoreFooter.h"
#import "StatusCell.h"
#import "StatusFrame.h"
#import "MJRefresh.h"
#import "StatusTool.h"

@interface HomeViewController ()<DropdownMenuDelegate>
/**
 *  微博数组（StatusFrame模型，一个StatusFrame对象就代表一条微博）
 */
@property (strong, nonatomic) NSMutableArray *statusFrames;


@end

@implementation HomeViewController
#pragma mark - 懒加载
- (NSMutableArray *)statusFrames
{
    if (_statusFrames == nil) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ios8设置application badge value
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    self.view.backgroundColor = Color(200, 200, 200);
    
    // 设置导航栏内容
    [self setupNav];
    
    // 设置首页navTitle
    [self setupTitle];
    
    // 下拉刷新
    [self setupDownRefresh];
    
    // 上拉刷新
    [self setupUpRefresh];
    
    // 获取未读数
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
//    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  获取未读数
 */
- (void)setupUnreadCount
{
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 取得账户模型
    Account *account = [AccountTool account];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 2.调用重写的HTTPTool方法发送请求
    [HTTPTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" params:params success:^(id json) {
        // 微博的未读数
        NSString *status = [json[@"status"] description];
        if ([status isEqualToString:@"0"]){
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else {
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(NSError *error) {
        Log(@"%@", error);
    }];
}

/**
 *  将Status模型转为StatusFrame模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *newFrames = [NSMutableArray array];
    for (Status *status in statuses) {
        StatusFrame *f = [[StatusFrame alloc] init];
        f.status = status;
        [newFrames addObject:f];
    }
    return newFrames;
}

/**
 *  上拉刷新
 */
- (void)setupUpRefresh
{
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatus)];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatus)];
//    // 设置文字
//    [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
//    [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
//    
//    // 设置尾部
//    self.tableView.footer = footer;
    // 设置字体
//    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置颜色
//    footer.stateLabel.textColor = [UIColor blueColor];
    // 设置刷新图片
//    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 旧方法
//    LoadMoreFooter *footer = [LoadMoreFooter footer];
//    footer.hidden = YES;
//    self.tableView.tableFooterView = footer;
}

/**
 *  下拉刷新
 */
- (void)setupDownRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewStatus:)];
    [self.tableView.header beginRefreshing];
//    UIRefreshControl *control = [[UIRefreshControl alloc] init];
//    [control addTarget:self action:@selector(refreshNewStatus:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:control];
//    
//    [control beginRefreshing];
//    [self refreshNewStatus:control];
    
}

// scrollView滚动到底部时，调用此方法
- (void)loadMoreStatus
{
    // 1.拼接参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    // 取出最后面的微博
    StatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        long long maxID = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxID);
    }
    
    // 添加一个block处理返回的字典数据
    void (^dealingResult)(NSArray *statuses) = ^(NSArray *statuses) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:statuses];
        // 将 Status数组 转为 StatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将最新的微博数据添加到数组的最前面
        //        NSRange range = NSMakeRange(0, newFrames.count);
        //        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        //        [self.statusFrames insertObjects:newFrames atIndexes:set];
        [self.statusFrames addObjectsFromArray:newFrames];
        // 刷新表格
        [self.tableView reloadData];
    };
    
    // 2.判断是否从沙盒中读取数据
    NSArray *statuses = [StatusTool statusesWithParams:params];
    if (statuses.count) {
        dealingResult(statuses);
        // 结束刷新，隐藏footer
//        self.tableView.tableFooterView.hidden = YES;
    } else {
//        return;
        // 3.调用重写的HTTPTool方法发送请求
        [HTTPTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
            // 存储最新数据到沙盒中
            [StatusTool saveStatuses:json[@"statuses"]];
            dealingResult(json[@"statuses"]);
            // 结束刷新，隐藏footer
//            [self.tableView footer];
        } failure:^(NSError *error) {
            Log(@"请求失败--%@", error);
            // 结束刷新，隐藏footer
//            self.tableView.tableFooterView.hidden = YES;
        }];
    }
    
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
- (void)refreshNewStatus:(UIRefreshControl *)control
{
    // 1.拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    params[@"access_token"] = account.access_token;
    
    StatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    //    params[@"count"] = @5;
    
    // 添加一个block处理返回的字典数据
    void (^dealingResult)(NSArray *statuses) = ^(NSArray *statuses) {
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:statuses];
        
        // 将 Status数组 转为 StatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        [self.tableView reloadData];
        
        [self showNewStatusCount:(int)newFrames.count];
        [control endRefreshing];
        [self setupUpRefresh];
    };
    
    // 2.判断是否从沙盒中读取数据
    NSArray *statuses = [StatusTool statusesWithParams:params];
    if (statuses.count) {
        dealingResult(statuses);
    } else {
        // 2.调用重写的HTTPTool方法发送请求
        [HTTPTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
            // 存储最新数据到沙盒中
            [StatusTool saveStatuses:json[@"statuses"]];
            //        Log(@"%@", responseObject);
            
            dealingResult(json[@"statuses"]);
            //        // 生成假数据
            //        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            //        dict[@"statuses"] = [Status keyValuesArrayWithObjectArray:newStatuses];
            //        dict[@"total_number"] = responseObject[@"total_number"];
            //        [dict writeToFile:@"/Users/xiaochen/Desktop/fakeStatus.plist" atomically:YES];
        } failure:^(NSError *error) {
            Log(@"请求失败--- %@", error);
            [control endRefreshing];
        }];
    }
}

/**
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(int)count
{
    // 刷新成功，清空图标数字
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    label.y = 64 - label.height;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.font = [UIFont systemFontOfSize:16];
    if (count == 0) {
        label.text = @"没有最新的微博";
    } else {
        label.text = [NSString stringWithFormat:@"您有%d条新的微博", count];
    }
    
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

/**
 *  设置首页navTitle
 */
- (void)setupTitle
{
    // 1.拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 2.调用重写的HTTPTool方法发送请求
    [HTTPTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        NSString *name = json[@"name"];
        [titleButton setTitle:name forState:UIControlStateNormal];
        // 存储到沙盒中
        account.name = name;
        [AccountTool saveAccount:account];
    } failure:^(NSError *error) {
        Log(@"请求失败--- %@", error);
    }];
}

/**
 *  设置首页导航按钮
 */
- (void)setupNav
{
    // 添加navigationBar两边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_friendsearch" highLightedImage:@"navigationbar_friendsearch_highlighted"target:self action:@selector(friendSearch)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_pop" highLightedImage:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    // 标题按钮
    TitleButton *titleBtn = [[TitleButton alloc] init]; // 调用initWithFrame:方法
    NSString *titleName = [AccountTool account].name;
    [titleBtn setTitle:titleName?titleName:@"首页" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.titleView = titleBtn;
}

- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu
{
    UIButton *btn = (UIButton *)self.navigationItem.titleView;
    btn.selected = NO;
}

- (void)dropdownMenuDidShow:(DropdownMenu *)menu
{
    UIButton *btn = (UIButton *)self.navigationItem.titleView;
    btn.selected = YES;
}

/**
 *  标题点击
 */
- (void)titleClick:(UIButton *)titleButton
{
    DropdownMenu *menu = [DropdownMenu menu];
    menu.delegate = self;
//    menu.content = [UIButton buttonWithType:UIButtonTypeContactAdd];
    TitleMenuController *vc = [[TitleMenuController alloc] init];
    
    vc.view.width = 100;
    vc.view.height = 200;
    
    menu.contentController = vc;
    [menu showFrom:titleButton];

    
//    Log(@"titleClick");
//    UIImageView *dropdownView = [[UIImageView alloc] init];
//    dropdownView.image = [UIImage imageNamed:@"popover_background"];
//    dropdownView.width = self.view.frame.size.width * 0.5;
//    dropdownView.height = dropdownView.width * 2;
//    dropdownView.x = dropdownView.width * 0.5;
//    dropdownView.y = 64;
//    
//    
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    [window addSubview:dropdownView];
}

- (void)friendSearch
{
    Log(@"friendSearch");
}

- (void)pop
{
    Log(@"pop");
}

#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusCell *cell = [StatusCell cellWithTableView:tableView];
    
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
    /**
//    NSDictionary *status = self.statuses[indexPath.row];
    Status *status = self.statuses[indexPath.row];
//    NSDictionary *user = status[@"user"];
//    User *user = status.user;
    // 设置名称
//    cell.textLabel.text = user[@"name"];
    cell.textLabel.text = status.user.name;
    // 设置内容
//    cell.detailTextLabel.text = status[@"text"];
    cell.detailTextLabel.text = status.text;
    // 设置头像
//    NSString *imageUrl = user[@"profile_image_url"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
     */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
}

@end
