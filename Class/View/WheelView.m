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

@property (nonatomic, strong) UIScrollView *canvas;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) BOOL firstDraw;

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
    


    [self setupPageControl];
}

- (void)setupPageControl
{
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

- (void)updateConstraints
{
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
        make.width.equalTo(@(width));
        make.height.equalTo(@100);
    }];
    
    [self.canvas mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.size.equalTo(self);
    }];

    __block NSInteger num = 0;
    [[self.canvas subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = (UIImageView *)obj;
        
        if (self.pageNum + 1 == idx)
        {
            CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
            CGFloat y = self.canvas.contentOffset.y;
            [self.canvas setContentOffset:CGPointMake(width, y)];
            self.firstDraw = YES;
        }
        
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
        CGFloat mainWidth = self.frame.size.width;
        make.left.equalTo(self).with.offset(mainWidth *.5 - HEIGHT_OF_PAGE_CONTROL *.5);
    }];

    [super updateConstraints];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
    if (self.firstDraw) {
        CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
        CGFloat y = self.canvas.contentOffset.y;
        [self.canvas setContentOffset:CGPointMake(width, y)];
        self.firstDraw = NO;
    }
    
    if (scrollView.contentOffset.x == 0) {
        CGFloat width = scrollView.frame.size.width;
        CGFloat y = scrollView.contentOffset.y;
        [scrollView setContentOffset:CGPointMake(width * self.pageNum, y) animated:NO];
    } else if (scrollView.contentOffset.x == scrollView.frame.size.width * (self.pageNum + 1)) {
        CGFloat width = scrollView.frame.size.width;
        CGFloat y = scrollView.contentOffset.y;
        [scrollView setContentOffset:CGPointMake(width, y)];
    }
    NSInteger offSet = 0;
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
    
    if (scrollView.contentOffset.x < [UIScreen mainScreen].applicationFrame.size.width) {
        offSet = [UIScreen mainScreen].applicationFrame.size.width * self.pageNum;
    } else if ([UIScreen mainScreen].applicationFrame.size.width < scrollView.contentOffset.x && scrollView.contentOffset.x < [UIScreen mainScreen].applicationFrame.size.width * (self.pageNum + 1)) {
        offSet = scrollView.contentOffset.x - width;
    } else {
        offSet = scrollView.contentOffset.x - width * (self.pageNum + 1);
    }

    self.pageControl.currentPage = (NSInteger)(offSet / scrollView.frame.size.width);
}

@end
