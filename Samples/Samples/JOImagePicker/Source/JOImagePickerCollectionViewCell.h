//
//  JOImagePickerCollectionViewCell.h
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JOImagePickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView*    imageView;

@property (nonatomic, strong)   UIColor*        selectedColor;   // default greenColor

@property (nonatomic, copy)     NSString*       representedAssetIdentifier;

@end
