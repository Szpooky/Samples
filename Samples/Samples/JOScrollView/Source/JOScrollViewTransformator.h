//
//  JOScrollViewTransformator.h
//  JOScrollView
//
//  Created by Peter Sipos on 2018. 02. 21..
//  Copyright © 2018. Szpooky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JOScrollViewTransformator : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, strong)   UIView*     baseView;           // default nil

@property (nonatomic, strong)   UIView*     contentView;        // default nil. The view wich will transformed.

@property (nonatomic)           CGFloat     minimumZoomScale;   // default is 1.0

@property (nonatomic)           CGFloat     maximumZoomScale;   // default is 100.0

@property (nonatomic, readonly) UIPinchGestureRecognizer* pinchGesture;

@property (nonatomic, readonly) UIPanGestureRecognizer* panGesture;

@property (nonatomic, readonly) UIRotationGestureRecognizer* rotationGesture;

@property (nonatomic, readonly) UITapGestureRecognizer* doubleTapGesture;

// override points
- (void)pinchGestureAction:(UIPinchGestureRecognizer*)gesture;

- (void)panGestureAction:(UIPanGestureRecognizer*)gesture;

- (void)rotationGestureAction:(UIRotationGestureRecognizer*)gesture;

- (void)doubleTapGestureAction:(UITapGestureRecognizer*)gesture;

- (void)resetAnimated:(BOOL)animated;

@end
