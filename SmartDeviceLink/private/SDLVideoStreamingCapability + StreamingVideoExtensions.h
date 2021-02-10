//
//  SDLVideoStreamingCapability + StreamingVideoExtensions.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/31/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLVideoStreamingCapability.h"

@class SDLImageResolution;

NS_ASSUME_NONNULL_BEGIN

@interface SDLVideoStreamingCapability (StreamingVideoExtensions)

// this returns a copy array of all capabilities including itself but with no recursion
// in the result objects the .additionalVideoStreamingCapabilities will be nil
- (NSArray <SDLVideoStreamingCapability *> *)allVideoStreamingCapabilitiesPlain;

- (SDLImageResolution *)makeImageResolution;

- (NSArray<SDLImageResolution *> *)allImageResolutionsScaled;

- (NSArray<SDLImageResolution *> *)allImageResolutions;

@end

NS_ASSUME_NONNULL_END
