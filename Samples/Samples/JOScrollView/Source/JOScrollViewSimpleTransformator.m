//
//  JOScrollViewSimpleTransformator.m
//  JOScrollView
//
//  Created by Peter Sipos on 2018. 02. 21..
//  Copyright © 2018. Szpooky. All rights reserved.
//

#import "JOScrollViewSimpleTransformator.h"

@implementation JOScrollViewSimpleTransformator
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

- (void)setContentView:(UIView *)contentView
{
    [super setContentView:contentView];
    
    contentView.frame = self.baseView.bounds;
    
    [self resetAnimated:NO];
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
    
    CGPoint changes = CGPointMake([gesture translationInView:self.baseView].x / _currentScale, [gesture translationInView:self.baseView].y / _currentScale);
    
    changes = CGPointApplyAffineTransform(changes, CGAffineTransformRotate(CGAffineTransformIdentity, -1.0 * _currentRotation));
    
    _currentTranslate.x = changes.x  + _previousTranslate.x;
    _currentTranslate.y = changes.y + _previousTranslate.y;
    
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
    self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, _currentRotation);
    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, _currentScale, _currentScale);
    self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, _currentTranslate.x, _currentTranslate.y);
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
