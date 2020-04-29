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

/// Called when protocol instance for audio and/or video service has been updated.
///
/// If `newVideoProtocol` or `newAudioProtocol` is nil it indicates that underlying transport has become unavailable.
///
/// @param oldVideoProtocol protocol instance that was being used for video streaming
/// @param newVideoProtocol protocol instance that will be used for video streaming
/// @param oldAudioProtocol protocol instance that was being used for audio streaming
/// @param newAudioProtocol protocol instance that will be used for audio streaming
- (void)didUpdateFromOldVideoProtocol:(nullable SDLProtocol *)oldVideoProtocol toNewVideoProtocol:(nullable SDLProtocol *)newVideoProtocol fromOldAudioProtocol:(nullable SDLProtocol *)oldAudioProtocol toNewAudioProtocol:(nullable SDLProtocol *)newAudioProtocol;

@end

NS_ASSUME_NONNULL_END
