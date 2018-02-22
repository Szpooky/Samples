//
//  JOScrollViewMaskedSimpleViewController.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOScrollViewMaskedSimpleViewController.h"
#import "JOScrollView.h"
#import "JOCircleMaskView.h"

@interface JOScrollViewMaskedSimpleViewController ()

@end

@implementation JOScrollViewMaskedSimpleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Masked Simple";
    
    CGRect scrollViewRect = self.scrollView.frame;
    scrollViewRect.size.height += 100.0;
    self.scrollView.frame = scrollViewRect;
    
    [self.scrollView addSubview:[[JOCircleMaskView alloc] initWithFrame:self.scrollView.bounds]];
}

@end
