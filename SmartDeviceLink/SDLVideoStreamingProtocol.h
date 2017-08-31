//
//  SDLVideoStreamingProtocol.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 * Enum for each type of video streaming protocol
 *
 * @since SDL 4.7
 */
@interface SDLVideoStreamingProtocol : SDLEnum

/**
 * Convert String to SDLVideoStreamingProtocol
 *
 * @param value String value to retrieve the object for
 *
 * @return SDLVideoStreamingProtocol
 */
+ (SDLVideoStreamingProtocol *)valueOf:(NSString *)value;

/**
 @abstract Store the enumeration of all possible SDLVideoStreamingProtocol
 @return an array that store all possible SDLVideoStreamingProtocol
 */
+ (NSArray *)values;

/**
 @abstract SDLVideoStreamingProtocol : RAW
 */
+ (SDLVideoStreamingProtocol *)RAW;

/**
 @abstract SDLVideoStreamingProtocol : RTP
 */
+ (SDLVideoStreamingProtocol *)RTP;

/**
 @abstract SDLVideoStreamingProtocol : RTSP
 */
+ (SDLVideoStreamingProtocol *)RTSP;

/**
 @abstract SDLVideoStreamingProtocol : RTMP
 */
+ (SDLVideoStreamingProtocol *)RTMP;

/**
 @abstract SDLVideoStreamingProtocol : WEBM
 */
+ (SDLVideoStreamingProtocol *)WEBM;

@end
