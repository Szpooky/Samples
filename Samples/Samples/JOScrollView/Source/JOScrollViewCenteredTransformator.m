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
    CGPoint leftTop, rightTop, rightBottom, leftBottom, center;
    CGFloat width, height;
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

void calculateSquareSize(Square* square)
{
    if(square)
    {
        square->width = square->rightTop.x - square->leftTop.x;
        square->height = square->leftBottom.y - square->leftTop.y;
        
        square->center = CGPointMake(roundf(square->width / 2.0 + square->leftTop.x), roundf(square->height / 2.0 + square->leftTop.y));
    }
}

Square applyAffineTransformOnSquare(Square square, CGAffineTransform transform)
{
    Square retVal;
    
    retVal.leftTop = CGPointApplyAffineTransform(square.leftTop, transform);
    retVal.rightTop = CGPointApplyAffineTransform(square.rightTop, transform);
    retVal.rightBottom = CGPointApplyAffineTransform(square.rightBottom, transform);
    retVal.leftBottom = CGPointApplyAffineTransform(square.leftBottom, transform);
    
    calculateSquareSize(&retVal);
    
    // Create "Integers" from Floats
    retVal.leftTop.x = roundf(retVal.leftTop.x);
    retVal.leftTop.y = roundf(retVal.leftTop.y);
    
    retVal.rightTop.x = roundf(retVal.rightTop.x);
    retVal.rightTop.y = roundf(retVal.rightTop.y);
    
    retVal.rightBottom.x = roundf(retVal.rightBottom.x);
    retVal.rightBottom.y = roundf(retVal.rightBottom.y);
    
    retVal.leftBottom.x = roundf(retVal.leftBottom.x);
    retVal.leftBottom.y = roundf(retVal.leftBottom.y);
    
    retVal.center.x = roundf(retVal.center.x);
    retVal.center.y = roundf(retVal.center.y);
    
    return retVal;
}

Square squareFromView(CGRect rect, CGPoint center)
{
    Square retVal;
    
    retVal.leftTop = CGPointMake(CGRectGetMinX(rect) - center.x, CGRectGetMinY(rect) - center.y);
    retVal.rightTop = CGPointMake(CGRectGetMinX(rect) - center.x + CGRectGetWidth(rect), CGRectGetMinY(rect) - center.y);
    retVal.rightBottom = CGPointMake(CGRectGetMinX(rect) - center.x + CGRectGetWidth(rect), CGRectGetMinY(rect) - center.y + CGRectGetHeight(rect));
    retVal.leftBottom = CGPointMake(CGRectGetMinX(rect) - center.x, CGRectGetMinY(rect) - center.y + CGRectGetHeight(rect));
    
    return retVal;
}

CGRect rectFromSquare(Square square, CGPoint center)
{
    CGRect retVal;
    
    retVal.origin.x = center.x + square.leftTop.x;
    retVal.origin.y = center.y + square.leftTop.y;
    
    retVal.size.width = square.rightTop.x - square.leftTop.x;
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
    return rectFromSquare(applyAffineTransformOnSquare(canvas.content, transformFromCanvas(canvas)), canvas.center);
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

    self.maximumZoomScale = _originalSize.width / _minimumRect.size.width;
    
    [self resetAnimated:NO];
}

- (void)layoutBaseView
{
    _canvas.center = CGPointMake(roundf(self.baseView.bounds.size.width / 2.0), roundf(self.baseView.bounds.size.height / 2.0));
    
    _canvas.base = squareFromView(self.baseView.bounds, _canvas.center);
    
    calculateSquareSize(&_canvas.base);
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer*)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        _canvas.previousScale = _canvas.currentScale;
    }
    
    CGFloat scale = [gesture scale];
    _canvas.currentScale = MAX(MIN(scale * _canvas.previousScale, self.maximumZoomScale), self.minimumZoomScale);
    
    [self keepInBounds];
    
    [self applyGestureTransformations];
}

- (void)panGestureAction:(UIPanGestureRecognizer*)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        _canvas.previousTranslate = _canvas.currentTranslate;
    }
    
    CGPoint translate = [gesture translationInView:self.baseView];
    
    CGPoint changes = CGPointMake(translate.x / _canvas.currentScale, translate.y / _canvas.currentScale);

    Square square = applyAffineTransformOnSquare(_canvas.content, transformFromCanvas(_canvas));
    
    calculateSquareSize(&square);
    
    if(square.width > _canvas.base.width)
    {
        _canvas.currentTranslate.x = changes.x  + _canvas.previousTranslate.x;
    }
    else
    {
        _canvas.currentTranslate.x = 0.0;
    }
    
    if(square.height > _canvas.base.height)
    {
        _canvas.currentTranslate.y = changes.y + _canvas.previousTranslate.y;
    }
    else
    {
        _canvas.currentTranslate.y = 0.0;
    }
    
    [self keepInBounds];
    
    [self applyGestureTransformations];
}

- (void)keepInBounds
{
    Square square = applyAffineTransformOnSquare(_canvas.content, transformFromCanvas(_canvas));
    
    calculateSquareSize(&square);
    
    if(square.width > _canvas.base.width)
    {
        if(square.leftTop.x > _canvas.base.leftTop.x)
        {
            _canvas.currentTranslate.x -= (square.leftTop.x - _canvas.base.leftTop.x) / _canvas.currentScale;
        }
        
        if(square.rightTop.x < _canvas.base.rightTop.x)
        {
            _canvas.currentTranslate.x += (_canvas.base.rightTop.x - square.rightTop.x) / _canvas.currentScale;
        }
    }
    else
    {
        _canvas.currentTranslate.x -= (square.center.x - _canvas.base.center.x) / _canvas.currentScale;
    }
    
    if(square.height > _canvas.base.height)
    {
        if(square.leftTop.y > _canvas.base.leftTop.y)
        {
            _canvas.currentTranslate.y -= (square.leftTop.y - _canvas.base.leftTop.y) / _canvas.currentScale;
        }
        
        if(square.leftBottom.y < _canvas.base.leftBottom.y)
        {
            _canvas.currentTranslate.y += (_canvas.base.leftBottom.y - square.leftBottom.y) / _canvas.currentScale;
        }
    }
    else
    {
        _canvas.currentTranslate.y -= (square.center.y - _canvas.base.center.y) / _canvas.currentScale;
    }
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
        [self keepInBounds];
        CGRect frame = contentRectFromCanvas(_canvas);
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.contentView.frame = frame;
            
        }];
    }
    else
    {
        [self keepInBounds];
        [self applyGestureTransformations];
    }
}

@end
