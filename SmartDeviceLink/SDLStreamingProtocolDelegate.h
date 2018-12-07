//
//  SDLStreamingProtocolDelegate.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/03/23.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLStreamingProtocolDelegate <NSObject>

/**
 *  Called when protocol instance for audio service has been updated.
 *
 *  If `newProtocol` is nil, it indicates that underlying transport
 *  becomes unavailable.
 *
 *  @param oldProtocol protocol instance that has been used for audio streaming.
 *  @param newProtocol protocol instance that will be used for audio streaming.
 */
- (void)audioServiceProtocolDidUpdateFromOldProtocol:(nullable SDLProtocol *)oldProtocol toNewProtocol:(nullable SDLProtocol *)newProtocol;

/**
 *  Called when protocol instance for video service has been updated.
 *
 *  If `newProtocol` is nil, it indicates that underlying transport
 *  becomes unavailable.
 *
 *  @param oldProtocol protocol instance that has been used for video streaming.
 *  @param newProtocol protocol instance that will be used for video streaming.
 */
- (void)videoServiceProtocolDidUpdateFromOldProtocol:(nullable SDLProtocol *)oldProtocol toNewProtocol:(nullable SDLProtocol *)newProtocol;

@end

NS_ASSUME_NONNULL_END
