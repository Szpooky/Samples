//
//  JOScrollView.h
//  JOScrollView
//
//  Created by Szpooky on 2018. 02. 20..
//  Copyright © 2018. Szpooky. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JOScrollView;
@class JOScrollViewTransformator;

@protocol JOScrollViewDelegate <NSObject>

- (void)scrollViewDidZoom:(JOScrollView*)scrollView scale:(CGFloat)scale;

@end

@interface JOScrollView : UIView

@property (nonatomic, weak)     id<JOScrollViewDelegate>        delegate;

@property (nonatomic, strong)   JOScrollViewTransformator*      transformator;

@property (nonatomic, strong)   UIView*                         view;               // default nil

@property (nonatomic)           BOOL                            bouncing;           // default YES

@property (nonatomic)           CGFloat                         minimumZoomScale;   // default is 1.0

@property (nonatomic)           CGFloat                         maximumZoomScale;   // default is 100.0

@end
