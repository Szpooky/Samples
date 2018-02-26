//
//  JOScrollViewCenteredViewController.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 25..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOScrollViewCenteredViewController.h"
#import "JOScrollView.h"
#import "JOScrollViewCenteredTransformator.h"

@interface JOScrollViewCenteredViewController ()

@end

@implementation JOScrollViewCenteredViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Simple";
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 100.0, CGRectGetWidth(self.view.bounds), 60.0)];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.text = @"Gestures:\npinch, pan, rotation, double tap, tap (only log)";
    [self.view addSubview:label];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bridge"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [imageView addGestureRecognizer:tapGesture];
    
    CGFloat paddingX = 20.0;
    CGFloat sideSize = CGRectGetWidth(self.view.bounds) - paddingX * 2.0;
    _scrollView = [[JOScrollView alloc] initWithFrame:CGRectMake(paddingX, floorf(CGRectGetHeight(self.view.bounds) / 2.0 - sideSize / 2.0), sideSize, sideSize)];
    self.scrollView.transformator = [JOScrollViewCenteredTransformator new];
    self.scrollView.view = imageView;
    self.scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.scrollView];
    
    UIView* coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    coverView.userInteractionEnabled = NO;
    [self.view addSubview:coverView];
}

- (void)tapGestureAction:(id)sender
{
    NSLog(@"tap");
}

@end
