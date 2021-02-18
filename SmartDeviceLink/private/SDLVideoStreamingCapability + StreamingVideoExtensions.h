//
//  SDLVideoStreamingCapability + StreamingVideoExtensions.h
//  SmartDeviceLink-iOS
//
//  Created by yoooriii on 2/13/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLVideoStreamingCapability.h"

@class SDLImageResolution;

NS_ASSUME_NONNULL_BEGIN

@interface SDLVideoStreamingCapability (StreamingVideoExtensions)

// this returns a copy array of all capabilities including itself
// in the result objects the .additionalVideoStreamingCapabilities will be ommited
- (NSArray <SDLVideoStreamingCapability *> *)allVideoStreamingCapabilities;

/**
 Create a SDLImageResolution from  preferredResolution respecting the scale factor
 @return SDLImageResolution - an initialized image resolution struct
 */
- (SDLImageResolution *)makeImageResolution;

/**
 It traverces through all capabilities and collects all image resolutions into an array respecting the scale factor
 @return [SDLImageResolution] - an array of initialized image resolution structs
 */
- (NSArray<SDLImageResolution *> *)allImageResolutionsScaled;

/**
 It traverces through all capabilities and collects all image resolutions into an array ignoring the scale factor
 @return [SDLImageResolution] - an array of initialized image resolution structs
 */
- (NSArray<SDLImageResolution *> *)allImageResolutions;

/**
 It produces a shallow copy of itself object, additionalVideoStreamingCapabilities will be nil
 */
- (instancetype)shortCopy;

@end

NS_ASSUME_NONNULL_END
