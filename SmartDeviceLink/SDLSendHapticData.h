//
//  SDLSendHapticData.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLRPCRequest.h"

@class SDLHapticRect;

NS_ASSUME_NONNULL_BEGIN

/**
 *   Sends the spatial data gathered from SDLCarWindow or VirtualDisplayEncoder to the HMI. This data will be utilized by the HMI to determine how and when haptic events should occur.
 */
@interface SDLSendHapticData : SDLRPCRequest

/**
 *  Constructs a new SDLSendHapticData object indicated by the hapticSpatialData parameter
 *
 *  @param hapticRectData Array of spatial data structures
 */
- (instancetype)initWithHapticRectData:(NSArray<SDLHapticRect *> *)hapticRectData;

/**
 *  Array of spatial data structures that represent the locations of all user controls present on the HMI. This data should be updated if/when the application presents a new screen. When a request is sent, if successful, it will replace all spatial data previously sent through RPC. If an empty array is sent, the existing spatial data will be cleared
 *
 *  Optional, Array of SDLHapticRect, Array size 0 - 1,000
 */
@property (strong, nonatomic, nullable) NSArray<SDLHapticRect *> *hapticRectData;

@end

NS_ASSUME_NONNULL_END
