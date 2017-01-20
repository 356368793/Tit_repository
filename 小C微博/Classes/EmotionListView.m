//
//  EmotionListView.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/8.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "EmotionListView.h"
#import "EmotionPageView.h"

@interface EmotionListView()<UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;

@end

@implementation EmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.创建UIPageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
//        pageControl.backgroundColor = RandomColor;
        // 当只有1页时，自动隐藏pageControl
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        [UIImage imageNamed:@"compose_keyboard_dot_selected"];
        // 设置pageControl的图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        // 2.创建UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 删除之前的控件
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger count = (emotions.count + EmotionPageSize - 1) / EmotionPageSize;
    // 1.设置页数
    self.pageControl.numberOfPages = count;
    
    // 2.创建用来显示每一页表情的控件
    for (int i = 0; i < count; i++) {
        EmotionPageView *pageView = [[EmotionPageView alloc] init];
        
        NSRange range;
        range.location = i * EmotionPageSize;
        if (emotions.count - range.location >= EmotionPageSize) {
            range.length = EmotionPageSize;
        } else {
            range.length = emotions.count - range.location;
        }
        
        pageView.emotions = [emotions subarrayWithRange:range];
        
        [self.scrollView addSubview:pageView];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger count = self.scrollView.subviews.count;
    
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
    for (int i = 0; i < count; i++) {
        EmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.width = self.scrollView.width;
        pageView.height = self.scrollView.height;
        pageView.x = pageView.width * i;
        pageView.y = 0;
    }
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 10);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = self.scrollView.contentOffset.x / self.scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

@end
