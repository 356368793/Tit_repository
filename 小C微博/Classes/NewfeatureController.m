//
//  NewfeatureController.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/1.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "NewfeatureController.h"
#import "MainViewController.h"
#define kNewfeatureImageCount 4

@interface NewfeatureController()<UIScrollViewDelegate>
@property (weak, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) UIScrollView *scrollView;
@end

@implementation NewfeatureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.size = self.view.size;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 2.添加imageView
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i < kNewfeatureImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i+1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        if (i == kNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    // 3.设置scrollView属性
    scrollView.contentSize = CGSizeMake(kNewfeatureImageCount * scrollW, 0);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.添加pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 50;
    pageControl.numberOfPages = kNewfeatureImageCount;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    // 1.设置分享按钮
    UIButton *shareBtn = [[UIButton alloc] init];
    shareBtn.frame = CGRectMake(self.scrollView.width * 0.5 - 60, self.scrollView.height * 0.65, 120, 40);
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    
    [imageView addSubview:shareBtn];
    
    // 2.设置开始按钮
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.x = self.scrollView.width * 0.5 - startBtn.currentBackgroundImage.size.width * 0.5;
    startBtn.centerY = self.scrollView.height * 0.72;
    startBtn.size = startBtn.currentBackgroundImage.size;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
//    startBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    startBtn.backgroundColor = [UIColor redColor];
    [imageView addSubview:startBtn];
}

- (void)shareBtnClick:(UIButton *)button
{
    button.selected = !button.isSelected;
}

- (void)startBtnClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[MainViewController alloc] init];

    // 控制器不会被销毁，不建议使用
//    [self presentViewController:[[MainViewController alloc] init] animated:YES completion:nil];
}

- (void)dealloc
{
//    Log(@"NewfeatureController-dealloc");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page+0.5);
}

@end
