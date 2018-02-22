//
//  JOPhotoManager.h
//  Samples
//
//  Created by Peter Sipos on 2018. 02. 22..
//  Copyright © 2018. Peter Sipos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface JOPhotoManager : NSObject <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHFetchResult* cameraRollPhotos;

@property (nonatomic, copy) void(^assetsRefreshBlock)(void);        // called when assets have been changed

- (void)checkAuthorizationStatusAndFetchWithCompletionBlock:(void (^)(BOOL success))result;

@end
