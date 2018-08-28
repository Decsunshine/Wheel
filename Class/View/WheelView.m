//
//  WheelView.m
//  wheel
//
//  Created by honglianglu on 2/15/15.
//  Copyright (c) 2015 honglianglu. All rights reserved.
//

#import "WheelView.h"
#import "UIImageView+AFNetworking.h"
#import "View+MASAdditions.h"

#define HEIGHT_OF_PAGE_CONTROL 20.f

@interface WheelView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *banners;

@end

@implementation WheelView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.canvas = [[UIScrollView alloc] init];
        self.canvas.delegate = self;
        [self addSubview:self.canvas];
    }
    return self;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)launchWithImageUrlArray:(NSArray *)imageUrlArray
{
    self.pageNum = imageUrlArray.count;
    NSURL *firstImageUrl = [NSURL URLWithString:[imageUrlArray firstObject]];
    NSURL *lastImageUrl = [NSURL URLWithString:[imageUrlArray lastObject]];
    
    [self loadImage:lastImageUrl];
    [imageUrlArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *urlString = (NSString *)obj;
        [self loadImage:[NSURL URLWithString:urlString]];
    }];
    [self loadImage:firstImageUrl];

    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.pageNum;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)loadImage:(NSURL *)imageUrl
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:imageUrl];
    [self.canvas addSubview:imageView];
}


- (void)setUpPagingViewWithBanners
{
    [self.pageView removeAllSubviews];
    if (self.banners.count == 0) {
        return;
    } else if (self.banners.count == 1) {
        MTCBannerView *bannerView = [[MTCBannerView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [bannerView setTarget:self.target andTapAction:self.tapAction];
        bannerView.banner = [self.banners objectAtIndex:0];
        [self.pageView addSubview:bannerView];
        self.pageView.contentSize = CGSizeMake(self.pageView.width, self.pageView.height);
        self.pageView.scrollEnabled = NO;
    } else if (self.banners.count > 1) {
        for (int index = 0; index < self.banners.count + 2; index++) {
            MTCBannerView *bannerView = [[MTCBannerView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            [bannerView setTarget:self.target andTapAction:self.tapAction];
            MTCBanner *banner;
            if (index == 0) {
                banner = [self.banners objectAtIndex:self.banners.count - 1];
            } else if (index == self.banners.count + 1) {
                banner = [self.banners objectAtIndex:0];
            } else {
                banner = [self.banners objectAtIndex:index - 1];
            }
            bannerView.banner = banner;
            bannerView.left = bannerView.width * index;
            [self.pageView addSubview:bannerView];
        }
        self.pageView.contentSize = CGSizeMake(self.width * (self.banners.count + 2), self.pageView.height);
        self.pageView.contentOffset = CGPointMake(self.width, 0);
        self.pageView.scrollEnabled = YES;
    } else {
        //donothing
    }
}

- (void)updateConstraints
{
    [self.canvas mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.size.equalTo(self);
    }];

    __block NSInteger num = 0;
    [[self.canvas subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = (UIImageView *)obj;
        
        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.canvas).with.offset(-64);
            make.width.equalTo(self.canvas);
            make.height.equalTo(self.canvas);
            if (num == 0) {
                make.left.equalTo(self.canvas.mas_left);
            } else if (num == self.pageNum + 1) {
                UIImageView *lastImageView = [self.canvas subviews][idx - 1];
                make.left.equalTo(lastImageView.mas_right);
                make.right.equalTo(self.canvas.mas_right);
            } else if (num < self.pageNum + 1) {
                UIImageView *lastImageView = [self.canvas subviews][idx - 1];
                make.left.equalTo(lastImageView.mas_right);
            }
            num ++;
        }];
    }];
    
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@(HEIGHT_OF_PAGE_CONTROL));
        make.top.equalTo(self.mas_bottom).with.offset(-HEIGHT_OF_PAGE_CONTROL);
        make.left.equalTo(self);
    }];

    [super updateConstraints];
}


- (void)startTimer
{
    if (self.pageNum > 1 && !self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(ticking) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)ticking
{
    if (self.canvas == nil || self.pageNum == 0) {
        return;
    }
    
    int curPage = [self currentPage];
    NSLog(@"-----curpage---%d", curPage);
    if (curPage == 0) {
        [self.canvas scrollRectToVisible:CGRectMake(self.width * self.pageNum, 0, self.width, self.height) animated:YES];
    } else if (curPage == (self.pageNum + 1)) {
        [self.canvas scrollRectToVisible:CGRectMake(self.width, 0, self.width, self.height) animated:YES];
    } else {
        [self.canvas scrollRectToVisible:CGRectMake(self.width * (curPage + 1), 0, self.width, self.height) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
    
    NSInteger offSet = 0;
    if (scrollView.contentOffset.x < width) {
        offSet = width * self.pageNum;
    } else if (width < scrollView.contentOffset.x && scrollView.contentOffset.x < width * (self.pageNum + 1)) {
        offSet = scrollView.contentOffset.x - width;
    } else {
        offSet = scrollView.contentOffset.x - width * (self.pageNum + 1);
    }
    
    self.pageControl.currentPage = (NSInteger)(offSet / scrollView.frame.size.width);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    CGFloat width = scrollView.frame.size.width;
    
    if (scrollView.contentOffset.x == 0) {
        [scrollView setContentOffset:CGPointMake(width * self.pageNum, y) animated:NO];
    } else if (scrollView.contentOffset.x == width * (self.pageNum + 1)) {
        [scrollView setContentOffset:CGPointMake(width, y) animated:NO];
    }
}
*/
- (int)currentPage
{
    return floor(self.canvas.contentOffset.x / self.canvas.frame.size.width);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = floor((self.canvas.contentOffset.x - self.canvas.frame.size.width / 2) / self.canvas.frame.size.width);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int curPage = [self currentPage];
    
    if (curPage == 0) {
        [self.canvas scrollRectToVisible:CGRectMake(self.width * self.pageNum, 0, self.width, self.height) animated:NO];
    } else if (curPage == (self.pageNum + 1)) {
        [self.canvas scrollRectToVisible:CGRectMake(self.width, 0, self.width, self.height) animated:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int curPage = [self currentPage];
    
    if (curPage == self.pageNum + 1) {
        [scrollView scrollRectToVisible:CGRectMake(self.width, 0, self.width, self.height) animated:NO];
    }
}

@end
