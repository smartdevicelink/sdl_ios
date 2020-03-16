//
//  SDLCacheFileManager.h
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLOnSystemRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ImageRetrievalCompletionHandler)(UIImage * _Nullable image, NSError * _Nullable error);

@interface SDLCacheFileManager : NSObject

- (void)retrieveImageForRequest:(SDLOnSystemRequest *)request withCompletionHandler:(CacheImageReturnCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
