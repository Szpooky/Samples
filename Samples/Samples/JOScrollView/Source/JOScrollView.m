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
        
        UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self.transformator action:@selector(pinchGestureAction:)];
        pinchGesture.delegate = self.transformator;
        [self addGestureRecognizer:pinchGesture];
        
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transformator action:@selector(panGestureAction:)];
        panGesture.delegate = self.transformator;
        [self addGestureRecognizer:panGesture];
        
        UIRotationGestureRecognizer* rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self.transformator action:@selector(rotationGestureAction:)];
        rotationGesture.delegate = self.transformator;
        [self addGestureRecognizer:rotationGesture];
        
        UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.transformator action:@selector(doubleTapGestureAction:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGesture];
    }
}

- (void)setView:(UIView *)view
{
    _view = view;
    
    if(view)
    {
        [self addSubview:view];
        view.frame = self.bounds;
        self.transformator.contentView = view;
        [self.transformator resetAnimated:NO];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.view.frame = self.bounds;
    [self.transformator resetAnimated:NO];
}

@end
