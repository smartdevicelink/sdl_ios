//
//  SDLStreamingMediaManagerDataSource.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLImageResolution;
@class SDLVideoStreamingFormat;

NS_ASSUME_NONNULL_BEGIN

/// A data source for the streaming manager's preferred resolutions and preferred formats.
@protocol SDLStreamingMediaManagerDataSource <NSObject>

/**
 Implement to return a different preferred order of attempted format usage than the head unit's preferred order. In nearly all cases, it's best to simply return the head unit's preferred order, or not implement this method (which does the same thing).
 
 @warning If you return a format that is not supported by the StreamingMediaManager, that format will be skipped.
 
 @note If the head unit does not support the `GetSystemCapabilities` RPC, this method will not be called and H264 RAW will be used.

 @param headUnitPreferredOrder The head unit's preferred order of format usage. The first item is the one that will be used unless this proxy does not support it, then the next item, etc.
 @return Your preferred order of format usage.
 */
- (NSArray<SDLVideoStreamingFormat *> *)preferredVideoFormatOrderFromHeadUnitPreferredOrder:(NSArray<SDLVideoStreamingFormat *> *)headUnitPreferredOrder;

/**
 Implement to return a different resolution to use for video streaming than the head unit's requested resolution. If you return a resolution that the head unit does not like, the manager will fail to start up. In nearly all cases, it's best to simply return the head unit's preferred order, or not implement this method (which does the same thing), and adapt your UI to the head unit's preferred resolution instead.

 @param headUnitPreferredResolution The resolution the head unit requested to use.
 @return Your preferred order of image resolution usage. This system will not attempt more than 3 resolutions. It is strongly recommended that at least one resolution is the head unit's preferred resolution.
 */
- (NSArray<SDLImageResolution *> *)resolutionFromHeadUnitPreferredResolution:(SDLImageResolution *)headUnitPreferredResolution;

@end

NS_ASSUME_NONNULL_END
