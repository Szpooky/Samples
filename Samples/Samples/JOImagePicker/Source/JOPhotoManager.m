//
//  JOPhotoManager.m
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import "JOPhotoManager.h"

@interface JOPhotoManager ()

@property (nonatomic, strong) PHFetchResult* cameraRollAssetCollection;

@end

@implementation JOPhotoManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    
    return self;
}

#pragma mark - Setters

- (void)setCameraRollAssetCollection:(PHFetchResult*)cameraRollAssetCollection
{
    _cameraRollAssetCollection = cameraRollAssetCollection;
    
    [self fetchCameraRollPhotos];
}

#pragma mark - Photo Library Methods

- (void)checkAuthorizationStatusAndFetchWithCompletionBlock:(void (^)(BOOL success))result
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if(status == AVAuthorizationStatusAuthorized)
        {
            [self fetchCameraRollAssetCollection];
            
            if(result)
            {
                result(YES);
            }
        }
        else if(result)
        {
            result(NO);
        }
    }];
}

- (void)fetchCameraRollAssetCollection
{
    self.cameraRollAssetCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
}

- (void)fetchCameraRollPhotos
{
    BOOL refreshNeeded = NO;
    
    for (PHCollection* aCollection in self.cameraRollAssetCollection)
    {
        if ([aCollection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection* assetCollection = (PHAssetCollection*)aCollection;
            
            PHFetchOptions* allPhotosOptions = [PHFetchOptions new];
            allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            
            self.cameraRollPhotos = [PHAsset fetchAssetsInAssetCollection:assetCollection options:allPhotosOptions];
            
            refreshNeeded = YES;
        }
    }
    
    if(refreshNeeded && self.assetsRefreshBlock)
    {
        self.assetsRefreshBlock();
    }
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange*)changeInstance
{
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray<PHObject*>* changedObjects = @[];
        
        PHFetchResult* assetCollectionsFetch = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        PHFetchResultChangeDetails* changeDetails = [PHFetchResultChangeDetails changeDetailsFromFetchResult:self.cameraRollAssetCollection
                                                                                               toFetchResult:assetCollectionsFetch
                                                                                              changedObjects:changedObjects];
        
        if (changeDetails != nil)
        {
            self.cameraRollAssetCollection = [changeDetails fetchResultAfterChanges];
        }
    });
}

@end

