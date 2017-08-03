//
//  SDLVideoStreamingCodec.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 * Enum for each type of video streaming codec
 *
 * @since SDL 4.7
 */
@interface SDLVideoStreamingCodec : SDLEnum

/**
 * Convert String to SDLVideoStreamingCodec
 *
 * @param value String value to retrieve the object for
 *
 * @return SDLVideoStreamingCodec
 */
+ (SDLVideoStreamingCodec *)valueOf:(NSString *)value;

/**
 @abstract Store the enumeration of all possible SDLVideoStreamingCodec
 @return an array that store all possible SDLVideoStreamingCodec
 */
+ (NSArray *)values;

/**
 @abstract SDLVideoStreamingCodec : H264
 */
+ (SDLVideoStreamingCodec *)H264;

/**
 @abstract SDLVideoStreamingCodec : H265
 */
+ (SDLVideoStreamingCodec *)H265;

/**
 @abstract SDLVideoStreamingCodec : Theora
 */
+ (SDLVideoStreamingCodec *)THEORA;

/**
 @abstract SDLVideoStreamingCodec : VP8
 */
+ (SDLVideoStreamingCodec *)VP8;

/**
 @abstract SDLVideoStreamingCodec : VP9
 */
+ (SDLVideoStreamingCodec *)VP9;

@end
