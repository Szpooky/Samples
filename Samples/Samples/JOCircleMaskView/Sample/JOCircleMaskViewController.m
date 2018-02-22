//
//  JOCircleMaskViewController.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOCircleMaskViewController.h"
#import "JOScrollView.h"
#import "JOCircleMaskView.h"

@implementation JOCircleMaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"MaskView";
    
    UIBarButtonItem* infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Capture" style:UIBarButtonItemStyleDone target:self action:@selector(capture:)];
    [self.navigationItem setRightBarButtonItems:@[infoButton] animated:YES];
}

// iOS 11.2 bug workaround (related to the UIBarButtonItem highlight)
// https://stackoverflow.com/questions/47805224/uibarbuttonitem-will-be-always-highlight-when-i-click-it
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
}

#pragma mark - Actions

- (void)capture:(UIBarButtonItem*)sender
{
    UIViewController* captureVC = [UIViewController new];
    captureVC.view.backgroundColor = [UIColor whiteColor];
    captureVC.title = @"Captured Image";
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 300.0)];
    [captureVC.view addSubview:imageView];
    imageView.center = captureVC.view.center;
    imageView.image = [self captureImage];
    
    [self.navigationController pushViewController:captureVC animated:YES];
}

#pragma mark - Helper Methods

- (UIImage*)captureImage
{
    UIImage* retVal = nil;
    
    self.maskView.hidden = YES;
    
    UIGraphicsBeginImageContext(self.scrollView.bounds.size);
    [self.scrollView drawViewHierarchyInRect:self.scrollView.bounds afterScreenUpdates:YES];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], self.maskView.captureRect);
    UIImage* croppedImage = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    retVal = croppedImage;
    
    self.maskView.hidden = NO;
    
    return retVal;
}

@end
