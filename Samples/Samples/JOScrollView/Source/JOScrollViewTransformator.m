//
//  JOScrollViewTransformator.m
//  JOScrollView
//
//  Created by Peter Sipos on 2018. 02. 21..
//  Copyright © 2018. Szpooky. All rights reserved.
//

#import "JOScrollViewTransformator.h"

@implementation JOScrollViewTransformator

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 100.0;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer*)gesture
{

}

- (void)panGestureAction:(UIPanGestureRecognizer*)gesture
{

}

- (void)rotationGestureAction:(UIRotationGestureRecognizer*)gesture
{

}

- (void)doubleTapGestureAction:(UITapGestureRecognizer*)gesture
{

}

- (void)resetAnimated:(BOOL)animated
{
    
}

@end
