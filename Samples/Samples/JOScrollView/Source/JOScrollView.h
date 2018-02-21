//
//  JOScrollView.h
//  JOScrollView
//
//  Created by Szpooky on 2018. 02. 20..
//  Copyright © 2018. Szpooky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JOScrollViewTransformator;

@interface JOScrollView : UIView

@property (nonatomic, strong)   JOScrollViewTransformator*      transformator;

@property (nonatomic, strong)   UIView*                         view;               // default nil

#warning - Under Development
@property (nonatomic)           BOOL                            bouncing;           // default YES

@property (nonatomic)           BOOL                            enableRotation;     // default YES

@property (nonatomic)           BOOL                            enableTranslation;  // default YES

@property (nonatomic)           BOOL                            enableScaling;      // default YES

@property (nonatomic)           BOOL                            keepBounds;         // default NO

@property (nonatomic)           CGFloat                         minimumZoomScale;   // default is 1.0

@property (nonatomic)           CGFloat                         maximumZoomScale;   // default is 1.0

@end
