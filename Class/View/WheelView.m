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

@end

@implementation WheelView

- (instancetype)init
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
    [imageUrlArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *urlString = (NSString *)obj;
        [self loadImage:[NSURL URLWithString:urlString]];
    }];
    
    [self setupPageControl];
}

- (void)setupPageControl
{
    CGFloat mainWidth = self.frame.size.width, mainHeight = self.frame.size.height;
    CGSize size = CGSizeMake(mainWidth, HEIGHT_OF_PAGE_CONTROL);
    CGRect pcFrame = CGRectMake(mainWidth *.5 - size.width *.5, mainHeight - size.height + 50, size.width, size.height);
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:pcFrame];
    pageControl.numberOfPages = 5;
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
    [_canvas mas_updateConstraints:^(MASConstraintMaker *make) {
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
            } else if (num == 6) {
                UIImageView *lastImageView = [self.canvas subviews][idx - 1];
                make.left.equalTo(lastImageView.mas_right);
                make.right.equalTo(self.canvas.mas_right);
            } else if (num < 6) {
                UIImageView *lastImageView = [self.canvas subviews][idx - 1];
                make.left.equalTo(lastImageView.mas_right);
            }
            num ++;
        }];
    }];
    
    [super updateConstraints];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        CGFloat width = scrollView.frame.size.width;
        CGFloat y = scrollView.contentOffset.y;
        [scrollView setContentOffset:CGPointMake(width * 5, y) animated:NO];
    } else if (scrollView.contentOffset.x == scrollView.frame.size.width * 6) {
        CGFloat width = scrollView.frame.size.width;
        CGFloat y = scrollView.contentOffset.y;
        [scrollView setContentOffset:CGPointMake(width, y)];
    }
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
}

@end
