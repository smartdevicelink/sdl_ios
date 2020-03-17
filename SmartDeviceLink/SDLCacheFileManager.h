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

/**
 * Handles request to retrieve lock screen icon.
 *
 * @param request The System request used to retrieve the icon
 * @param completion The handler called when the manager retrieves the icon or fails to do so with an error. Use weak self when accessing self from the completion handler
*/
- (void)retrieveImageForRequest:(SDLOnSystemRequest *)request withCompletionHandler:(ImageRetrievalCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END

