//
//  JOCircleMaskView.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOCircleMaskView.h"

@implementation JOCircleMaskView
{
    CAShapeLayer*   _maskLayer;
    
    UIColor*        _testColor; // Set this to check captureRect
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = NO;
        self.padding = 20.0;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        self.layer.mask = _maskLayer;
        
        _captureRect = self.bounds;
        
        _testColor = nil; //[UIColor greenColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat radius = (CGRectGetWidth(self.frame) < CGRectGetHeight(self.frame)) ? CGRectGetWidth(self.frame) : CGRectGetHeight(self.frame);
    radius = floorf(radius / 2.0);
    radius -= self.padding;
    
    if(_testColor)
    {
        [_testColor setStroke];
    }
    
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(floorf(CGRectGetWidth(self.frame) / 2.0 - radius), floorf(CGRectGetHeight(self.frame) / 2.0 - radius), 2.0 * radius, 2.0 * radius) cornerRadius:radius];
    
    if(_testColor)
    {
        [circlePath stroke];
    }
    
    _captureRect = circlePath.bounds;
    [circlePath appendPath:[UIBezierPath bezierPathWithRect:self.bounds]];
    
    _maskLayer.path = circlePath.CGPath;
    
    if(_testColor)
    {
        [[UIColor greenColor] setStroke];
        UIBezierPath* rectPath = [UIBezierPath bezierPathWithRect:_captureRect];
        rectPath.lineWidth = 5;
        [rectPath stroke];
    }
}

@end
