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
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.wheelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
        make.width.equalTo(self.view);
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
    }];
    
    [super updateViewConstraints];
}
@end
