//
//  JOScrollViewOldTransformator.m
//  JOScrollView
//
//  Created by Peter Sipos on 2018. 02. 21..
//  Copyright © 2018. Szpooky. All rights reserved.
//

#import "JOScrollViewOldTransformator.h"

@implementation JOScrollViewOldTransformator
{
    // scale
    CGFloat     _previousScale;
    CGFloat     _currentScale;
    
    // translate
    CGPoint     _previousTranslate;
    CGPoint     _currentTranslate;
    
    // rotation
    CGFloat     _previousRotation;
    CGFloat     _currentRotation;
}

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

- (void)pinchGestureAction:(UIPinchGestureRecognizer*)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        _previousScale = _currentScale;
    }
    
    _currentScale = MAX(MIN([gesture scale] * _previousScale, self.maximumZoomScale), self.minimumZoomScale);
    
    [self applyGestureTransformations];
    
    if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled || [gesture state] == UIGestureRecognizerStateFailed)
    {
        // Gesture can fail (or cancelled?) when the notification and the object is dragged simultaneously
        // Do nothing
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer*)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        _previousTranslate = _currentTranslate;
    }
    
    _currentTranslate.x = [gesture translationInView:self.baseView].x + _previousTranslate.x;
    _currentTranslate.y = [gesture translationInView:self.baseView].y + _previousTranslate.y;
    
    [self applyGestureTransformations];
}

- (void)rotationGestureAction:(UIRotationGestureRecognizer*)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        _previousRotation = _currentRotation;
    }
    
    _currentRotation = _previousRotation + [gesture rotation];
    
    [self applyGestureTransformations];
}

- (void)applyGestureTransformations
{
    self.contentView.transform = CGAffineTransformIdentity;
    self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, _currentTranslate.x, _currentTranslate.y);
    self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, _currentRotation);
    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, _currentScale, _currentScale);
}

- (void)doubleTapGestureAction:(UITapGestureRecognizer*)gesture
{
    [self resetAnimated:gesture != nil];
}

- (void)resetAnimated:(BOOL)animated
{
    _previousTranslate.x = _previousTranslate.y = _currentTranslate.x = _currentTranslate.y = _previousRotation = _currentRotation = 0.0;
    _previousScale = _currentScale = 1.0;
    
    if(animated)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformIdentity;
        }];
    }
    else
    {
        self.contentView.transform = CGAffineTransformIdentity;
    }
}

@end
