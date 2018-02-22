//
//  JOImagePickerCollectionViewCell.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOImagePickerCollectionViewCell.h"

@implementation JOImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:self.imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.contentView.clipsToBounds = YES;
        
        self.selectedColor = [UIColor greenColor];
        
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.imageView.layer.borderWidth = selected ? 4.0 : 0.0;
}

- (void)setSelectedColor:(UIColor*)selectedColor
{
    _selectedColor = selectedColor;
    
    self.imageView.layer.borderColor = self.selectedColor ? self.selectedColor.CGColor : [UIColor greenColor].CGColor;
}

@end

