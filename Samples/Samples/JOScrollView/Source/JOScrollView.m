//
//  JOScrollView.m
//  JOScrollView
//
//  Created by Szpooky on 2018. 02. 20..
//  Copyright © 2018. Szpooky. All rights reserved.
//

#import "JOScrollView.h"
#import "JOScrollViewTransformator.h"

@implementation JOScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.view = nil;
    self.bouncing = YES;
    self.enableRotation = YES;
    self.enableTranslation = YES;
    self.enableScaling = YES;
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 100.0;
}

- (void)setTransformator:(JOScrollViewTransformator *)transformator
{
    if(_transformator != transformator)
    {
        _transformator = transformator;
        
        for(UIGestureRecognizer* gesture in self.gestureRecognizers)
        {
            [self removeGestureRecognizer:gesture];
        }
        
        self.transformator.baseView = self;
        self.transformator.minimumZoomScale = self.minimumZoomScale;
        self.transformator.maximumZoomScale = self.maximumZoomScale;
        [self addGestureRecognizer:self.transformator.pinchGesture];
        [self addGestureRecognizer:self.transformator.panGesture];
        [self addGestureRecognizer:self.transformator.rotationGesture];
        [self addGestureRecognizer:self.transformator.doubleTapGesture];
    }
}

- (void)setView:(UIView *)view
{
    if(view != self.transformator.contentView)
    {
        [self.transformator.contentView removeFromSuperview];
        
        self.transformator.contentView = view;
        
        if(view)
        {
            [self addSubview:view];
        }
    }
}

- (UIView*)view
{
    return self.transformator.contentView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.view.frame = self.bounds;
    [self.transformator resetAnimated:NO];
}

- (void)setBouncing:(BOOL)bouncing
{
    self.transformator.bouncing = bouncing;
}

- (BOOL)bouncing
{
    return self.transformator.bouncing;
}

@end
