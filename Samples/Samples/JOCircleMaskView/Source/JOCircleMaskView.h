//
//  JOCircleMaskView.h
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JOCircleMaskView : UIView

@property (nonatomic)           CGFloat         padding;        // default 20.0

@property (nonatomic, readonly) CGRect          captureRect;    // bounds of the circle

@end
