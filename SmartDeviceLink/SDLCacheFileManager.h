//
//  SDLCacheFileManager.h
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDLOnSystemRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLCacheFileManager : NSObject

- (void)handleLockScreenIconRequest:(SDLOnSystemRequest *)request;

- (BOOL)sdlCacheDirectoryExists;

@end

NS_ASSUME_NONNULL_END
