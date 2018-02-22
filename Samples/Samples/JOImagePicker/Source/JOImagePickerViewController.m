//
//  JOImagePickerViewController.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOImagePickerViewController.h"
#import "JOImagePickerCollectionViewCell.h"
#import "JOPhotoManager.h"


@interface JOImagePickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, readonly) NSMutableArray<UIImage*>*       images;

@property (nonatomic, strong)   UICollectionView*               photosCollectionView;

@property (nonatomic, strong)   UICollectionViewFlowLayout*     photosCollectionViewFlowLayout;

@property (nonatomic, assign)   CGSize                          assetSize;

@property (nonatomic, readonly) JOPhotoManager*                 photoManager;

@property (nonatomic, readonly) NSOperationQueue*               queue;

@property (nonatomic, strong)   UIColor*                        tempNavigationBarTintColor;

@end


@implementation JOImagePickerViewController

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.textColor = [UIColor whiteColor];
    self.selectedColor = [UIColor greenColor];
    
    _images = [NSMutableArray new];
    
    _queue = [NSOperationQueue new];
    [_queue setMaxConcurrentOperationCount:1];
    
    _photoManager = [JOPhotoManager new];
    
    __weak typeof(self) weakSelf = self;
    
    self.photoManager.assetsRefreshBlock = ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.photosCollectionView reloadData];
            
        });
    };
}

#pragma mark - LifeCycle Of View

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.photosCollectionViewFlowLayout = [UICollectionViewFlowLayout new];
    self.photosCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.photosCollectionViewFlowLayout];
    self.photosCollectionView.delegate = self;
    self.photosCollectionView.dataSource = self;
    self.photosCollectionView.allowsMultipleSelection = self.allowsMultipleSelection;
    self.photosCollectionView.backgroundColor = [UIColor blackColor];
    
    [self.photosCollectionView registerClass:[JOImagePickerCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
    
    self.view = self.photosCollectionView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat numberOfItemsInARow = 3.0;
    CGFloat spacing = 6.0;
    CGFloat itemWidth = (CGRectGetWidth(self.view.frame) - (numberOfItemsInARow - 1.0) * spacing) / numberOfItemsInARow;
    
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth);
    
    self.photosCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photosCollectionViewFlowLayout.itemSize = itemSize;
    self.photosCollectionViewFlowLayout.minimumLineSpacing = spacing;
    self.photosCollectionViewFlowLayout.minimumInteritemSpacing = spacing;
    
    self.photosCollectionView.allowsMultipleSelection = self.allowsMultipleSelection;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    self.assetSize =  CGSizeApplyAffineTransform(self.photosCollectionViewFlowLayout.itemSize, CGAffineTransformMakeScale(scale, scale));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.navigationController && [self.navigationController.viewControllers firstObject] == self)
    {
        UIBarButtonItem* cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        [cancelButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.textColor} forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    
    if(self.allowsMultipleSelection)
    {
        UIBarButtonItem* doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endMultipleSelection)];
        [doneButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.textColor} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = doneButtonItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.photoManager checkAuthorizationStatusAndFetchWithCompletionBlock:^(BOOL success) {
        
        if(success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photosCollectionView reloadData];
            });
        }
    }];
}

#pragma mark - Collection View Data Source and Delegate

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger retVal = self.photoManager.cameraRollPhotos.count;
    
    return retVal;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    JOImagePickerCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.selectedColor = self.selectedColor;
    
    PHAsset* asset = self.photoManager.cameraRollPhotos[indexPath.item];
    
    if (asset)
    {
        cell.representedAssetIdentifier = asset.localIdentifier;
        
        // Request an image for the asset from the PHCachingImageManager.
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                          targetSize:self.assetSize
                                                         contentMode:PHImageContentModeAspectFill
                                                             options:nil
                                                       resultHandler:^(UIImage* result, NSDictionary* info) {
                                                           
                                                           // Set the cell's thumbnail image if it's still showing the same asset.
                                                           if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier])
                                                           {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   cell.imageView.image = result;
                                                               });
                                                           }
                                                       }];
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL retVal = NO;
    
    NSUInteger selectionCounter = [collectionView indexPathsForSelectedItems].count;
    
    if(self.limitOfMultipleSelection == 0 || self.limitOfMultipleSelection > selectionCounter)
    {
        retVal = YES;
    }
    
    return retVal;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if(!self.allowsMultipleSelection)
    {
        [self endMultipleSelection];
    }
}

#pragma mark - Actions

- (void)endMultipleSelection
{
    [self.images removeAllObjects];
    
    NSArray<NSIndexPath*>* selectedItems = [self.photosCollectionView indexPathsForSelectedItems];

    __block NSUInteger operationCounter = 0;
    
    for(NSIndexPath* indexPath in selectedItems)
    {
        NSBlockOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
            
            PHAsset* asset = self.photoManager.cameraRollPhotos[indexPath.item];
            
            if (asset)
            {
                PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
                options.resizeMode = PHImageRequestOptionsResizeModeExact;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                options.version = PHImageRequestOptionsVersionOriginal;
                
                [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData* _Nullable imageData, NSString* _Nullable dataUTI, UIImageOrientation orientation, NSDictionary* _Nullable info) {
                    
                    if (imageData)
                    {
                        UIImage* image = [UIImage imageWithData:imageData];
                        
                        [self.images addObject:image];
                    }
                    
                    operationCounter++;
                    
                    if(operationCounter == selectedItems.count)
                    {
                        [self dismiss];
                    }
                }];
            }
        }];
        
        [self.queue addOperation:operation];
    }
}

- (void)dismiss
{
    if(self.completionBlock)
    {
        self.completionBlock(NO, [NSArray arrayWithArray:self.images]);
    }
}

- (void)cancel
{
    if(self.completionBlock)
    {
        self.completionBlock(YES, @[]);
    }
}

@end
