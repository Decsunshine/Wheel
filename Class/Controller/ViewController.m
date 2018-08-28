//
//  ViewController.m
//  wheel
//
//  Created by honglianglu on 2/15/15.
//  Copyright (c) 2015 honglianglu. All rights reserved.
//

#import "ViewController.h"
#import "WheelView.h"
#import "ImageUrl.h"
#import "View+MASAdditions.h"

@interface ViewController ()

@property (nonatomic, strong) WheelView *wheelView;
           
@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wheelView = [[WheelView alloc] init];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.wheelView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.wheelView launchWithImageUrlArray:[ImageUrl imageUrl]];

    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;

    self.wheelView.canvas.contentSize = CGSizeMake(width * (5 + 2), 100);
    self.wheelView.canvas.contentOffset = CGPointMake(width, 0);
    [self.wheelView startTimer];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;

    [self.wheelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
        make.width.equalTo(@(width));
        make.height.equalTo(@100);
    }];
    
    [super updateViewConstraints];
}
@end
