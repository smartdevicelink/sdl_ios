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

/// Called when protocol instance for audio and/or video service has been updated and the transport is established.
///
/// If `newVideoProtocol` or `newAudioProtocol` have been set then the transport is established and a current session can be started. If `newVideoProtocol` or `newAudioProtocol` is nil it indicates that underlying transport will become unavailable and any ongoing sessions on that transport should be stopped (i.e. send a request to the module to stop the session and wait for a response).
///
/// @param oldVideoProtocol protocol instance that was being used for video streaming
/// @param newVideoProtocol protocol instance that will be used for video streaming
/// @param oldAudioProtocol protocol instance that was being used for audio streaming
/// @param newAudioProtocol protocol instance that will be used for audio streaming
- (void)didUpdateFromOldVideoProtocol:(nullable SDLProtocol *)oldVideoProtocol toNewVideoProtocol:(nullable SDLProtocol *)newVideoProtocol fromOldAudioProtocol:(nullable SDLProtocol *)oldAudioProtocol toNewAudioProtocol:(nullable SDLProtocol *)newAudioProtocol;

/// Called when the audio and/or video must be stopped because the transport has been destroyed or errored out.
///
/// Since the transport does not exist, current sessions can not be properly stopped (i.e. no request can be sent module to stop the session) but the observer still needs to stop creating and sending data.
- (void)transportClosed;

@end

NS_ASSUME_NONNULL_END
