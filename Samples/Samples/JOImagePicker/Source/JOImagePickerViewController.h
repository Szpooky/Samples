//
//  JOImagePickerViewController.h
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JOImagePickerViewController : UIViewController

@property (nonatomic, strong)   UIColor*    textColor;

@property (nonatomic, strong)   UIColor*    selectedColor;              // default greenColor

@property (nonatomic, assign)   BOOL        allowsMultipleSelection;    // defualt NO

@property (nonatomic, assign)   NSUInteger  limitOfMultipleSelection;   // default 0 (0 means infinity)

@property (copy) void(^completionBlock)(BOOL isCanceled, NSArray<UIImage*>* images);

@end
