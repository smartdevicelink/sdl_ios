//
//  SDLStreamingDataManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
@import VideoToolbox;

#import "SDLProtocolListener.h"

@class SDLAbstractProtocol;


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SDLStreamingVideoError) {
    SDLStreamingVideoErrorHeadUnitNACK,
    SDLSTreamingVideoErrorInvalidOperatingSystemVersion,
    SDLStreamingVideoErrorConfigurationCompressionSessionCreationFailure,
    SDLStreamingVideoErrorConfigurationAllocationFailure,
    SDLStreamingVideoErrorConfigurationCompressionSessionSetPropertyFailure
};

typedef NS_ENUM(NSInteger, SDLStreamingAudioError) {
    SDLStreamingAudioErrorHeadUnitNACK
};

extern NSString *const SDLErrorDomainStreamingMediaVideo;
extern NSString *const SDLErrorDomainStreamingMediaAudio;

typedef void (^SDLStreamingStartBlock)(BOOL success, NSError *__nullable error);


@interface SDLStreamingMediaManager : NSObject <SDLProtocolListener>

- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol;

/**
 *  
 *
 *  @warning If this method is called on an 8.0 device, it will assert (in debug), or return a failure immediately to your block (in release).
 *
 *  @param startBlock A block that will be called with the result of attempting to start a video session
 */
- (void)startVideoSessionWithStartBlock:(SDLStreamingStartBlock)startBlock;
- (void)stopVideoSession;
- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer;

- (void)startAudioStreamingWithStartBlock:(SDLStreamingStartBlock)startBlock;
- (void)stopAudioSession;
- (BOOL)sendAudioData:(NSData *)pcmAudioData;

@end

NS_ASSUME_NONNULL_END
