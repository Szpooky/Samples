//
//  JOScrollViewCenteredTransformator.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 25..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOScrollViewCenteredTransformator.h"

typedef struct Square
{
    CGPoint leftTop, rigthTop, rightBottom, leftBottom;
}Square;

typedef struct Canvas
{
    Square base;
    Square content;
    CGPoint center;
    
    // scale
    CGFloat previousScale;
    CGFloat currentScale;
    
    // translate
    CGPoint previousTranslate;
    CGPoint currentTranslate;
}Canvas;

Square applyAffineTransform(Square square, CGAffineTransform transform)
{
    Square retVal;
    
    retVal.leftTop = CGPointApplyAffineTransform(square.leftTop, transform);
    retVal.rigthTop = CGPointApplyAffineTransform(square.rigthTop, transform);
    retVal.rightBottom = CGPointApplyAffineTransform(square.rightBottom, transform);
    retVal.leftBottom = CGPointApplyAffineTransform(square.leftBottom, transform);
    
    return retVal;
}

Square squareFromView(CGRect rect, CGPoint center)
{
    Square retVal;
    
    retVal.leftTop = CGPointMake(CGRectGetMinX(rect) - center.x, CGRectGetMinY(rect) - center.y);
    retVal.rigthTop = CGPointMake(CGRectGetMinX(rect) - center.x + CGRectGetWidth(rect), CGRectGetMinY(rect) - center.y);
    retVal.rightBottom = CGPointMake(CGRectGetMinX(rect) - center.x + CGRectGetWidth(rect), CGRectGetMinY(rect) - center.y + CGRectGetHeight(rect));
    retVal.leftBottom = CGPointMake(CGRectGetMinX(rect) - center.x, CGRectGetMinY(rect) - center.y + CGRectGetHeight(rect));
    
    return retVal;
}

CGRect rectFromSquare(Square square, CGPoint center)
{
    CGRect retVal;
    
    retVal.origin.x = center.x + square.leftTop.x;
    retVal.origin.y = center.y + square.leftTop.y;
    
    retVal.size.width = square.rigthTop.x - square.leftTop.x;
    retVal.size.height = square.leftBottom.y - square.leftTop.y;
    
    return retVal;
}

CGAffineTransform transformFromCanvas(Canvas canvas)
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, canvas.currentScale, canvas.currentScale);
    transform = CGAffineTransformTranslate(transform, canvas.currentTranslate.x, canvas.currentTranslate.y);
    return transform;
}

CGRect contentRectFromCanvas(Canvas canvas)
{
    return rectFromSquare(applyAffineTransform(canvas.content, transformFromCanvas(canvas)), canvas.center);
}

CGFloat ScaleToAspectFitRectInRect(CGRect rfit, CGRect rtarget)
{
    // first try to match width
    CGFloat s = CGRectGetWidth(rtarget) / CGRectGetWidth(rfit);
    // if we scale the height to make the widths equal, does it still fit?
    if (CGRectGetHeight(rfit) * s <= CGRectGetHeight(rtarget))
    {
        return s;
    }
    // no, match height instead
    return CGRectGetHeight(rtarget) / CGRectGetHeight(rfit);
}

CGRect AspectFitRectInRect(CGRect rfit, CGRect rtarget)
{
    CGFloat s = ScaleToAspectFitRectInRect(rfit, rtarget);
    CGFloat w = CGRectGetWidth(rfit) * s;
    CGFloat h = CGRectGetHeight(rfit) * s;
    CGFloat x = CGRectGetMidX(rtarget) - w / 2;
    CGFloat y = CGRectGetMidY(rtarget) - h / 2;
    return CGRectMake(floorf(x), floorf(y), floorf(w), floorf(h));
}

@implementation JOScrollViewCenteredTransformator
{
    // sizes
    CGSize      _originalSize;
    
    // rects
    CGRect      _minimumRect;
    
    Canvas      _canvas;
}

- (void)setBaseView:(UIView *)baseView
{
    [super setBaseView:baseView];
    
    [self layoutBaseView];
}

- (void)setContentView:(UIView *)contentView
{
    [super setContentView:contentView];
    
    _originalSize = contentView.frame.size;
    _minimumRect = AspectFitRectInRect(self.contentView.bounds, self.baseView.bounds);
    self.contentView.frame = _minimumRect;

    _canvas.content = squareFromView(_minimumRect, _canvas.center);
    
    [self resetAnimated:NO];
}

- (void)layoutBaseView
{
    _canvas.center = CGPointMake(roundf(self.baseView.bounds.size.width / 2.0), roundf(self.baseView.bounds.size.height / 2.0));
    
    _canvas.base = squareFromView(self.baseView.bounds, _canvas.center);
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer*)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        _canvas.previousScale = _canvas.currentScale;
    }
    
    _canvas.currentScale = MAX(MIN([gesture scale] * _canvas.previousScale, self.maximumZoomScale), self.minimumZoomScale);
    
    [self applyGestureTransformations];
}

- (void)panGestureAction:(UIPanGestureRecognizer*)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        _canvas.previousTranslate = _canvas.currentTranslate;
    }
    
    CGPoint changes = CGPointMake([gesture translationInView:self.baseView].x / _canvas.currentScale, [gesture translationInView:self.baseView].y / _canvas.currentScale);

    if(self.contentView.frame.size.width > self.baseView.frame.size.width)
    {
        _canvas.currentTranslate.x = changes.x  + _canvas.previousTranslate.x;
    }
    else
    {
        _canvas.currentTranslate.x = 0.0;
    }
    
    if(self.contentView.frame.size.height > self.baseView.frame.size.height)
    {
        _canvas.currentTranslate.y = changes.y + _canvas.previousTranslate.y;
    }
    else
    {
        _canvas.currentTranslate.y = 0.0;
    }
    
    [self applyGestureTransformations];
    
    /*
     CGRect bounds = [self moveAreaForSize:self.contentView.frame.size];
     
     CGPoint translate;
     translate.x = [gesture translationInView:self.baseView].x + _canvas.previousTranslate.x;
     translate.y = [gesture translationInView:self.baseView].y + _canvas.previousTranslate.y;
     
     
     CGRect transformedRect = CGRectApplyAffineTransform(_minimumRect, [self applyTransforms]);
    transformedRect.origin.x += _minimumRect.origin.x;
    transformedRect.origin.y += _minimumRect.origin.y;
    self.contentView.frame = transformedRect; return;
    
    if(CGRectGetMinX(transformedRect) > 0.0 && transformedRect.size.width > self.baseView.frame.size.width)
    {
        // Need Fix
        _currentTranslate.x = _currentTranslate.x + CGRectGetMinX(transformedRect);
    }
    if(CGRectGetMinY(transformedRect) > 0.0 && transformedRect.size.height > self.baseView.frame.size.height)
    {
        // Need Fix
        _currentTranslate.y = _currentTranslate.y + CGRectGetMinY(transformedRect);
    }
    
    if(CGRectGetMaxX(transformedRect) > CGRectGetWidth(self.baseView.bounds) && transformedRect.size.width > self.baseView.frame.size.width)
    {
        // Need Fix
        _currentTranslate.x = _currentTranslate.x + (CGRectGetMaxX(transformedRect) - CGRectGetWidth(self.baseView.bounds));
    }
    if(CGRectGetMaxY(transformedRect) > CGRectGetHeight(self.baseView.bounds) && transformedRect.size.height > self.baseView.frame.size.height)
    {
        // Need Fix
        _currentTranslate.y = _currentTranslate.y + (CGRectGetMaxY(transformedRect) - CGRectGetHeight(self.baseView.bounds));
    }
    
    [self applyGestureTransformations];*/
}

- (void)applyGestureTransformations
{
    CGRect frame = contentRectFromCanvas(_canvas);
    
    self.contentView.frame = frame;
}

- (void)doubleTapGestureAction:(UITapGestureRecognizer*)gesture
{
    [self resetAnimated:gesture != nil];
}

- (void)resetAnimated:(BOOL)animated
{
    _canvas.previousTranslate.x = _canvas.previousTranslate.y = _canvas.currentTranslate.x = _canvas.currentTranslate.y = 0.0;
    _canvas.previousScale = _canvas.currentScale = 1.0;
    
    if(animated)
    {
        CGRect frame = contentRectFromCanvas(_canvas);
        [UIView animateWithDuration:0.2 animations:^{
            
            self.contentView.frame = frame;
            
        }];
    }
    else
    {
        [self applyGestureTransformations];
    }
}

- (CGRect)moveAreaForSize:(CGSize)size
{
    CGSize moveArea = CGSizeMake(2.0 * size.width - _minimumRect.size.width, 2.0 * size.height - _minimumRect.size.height);
    
    return CGRectMake( floorf(CGRectGetWidth(self.baseView.bounds) / 2.0 - moveArea.width / 2.0), floorf(CGRectGetHeight(self.baseView.bounds) / 2.0 - moveArea.height / 2.0), moveArea.width, moveArea.height);
}

@end
