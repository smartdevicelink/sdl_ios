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


typedef void (^SDLStreamingLifecycleBlock)(BOOL success);


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingDataManager : NSObject <SDLProtocolListener>

- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol;

- (void)startVideoSessionWithStartBlock:(SDLStreamingLifecycleBlock)startBlock;
- (void)stopVideoSession;
- (BOOL)sendVideoData:(CMSampleBufferRef)bufferRef;

- (void)startAudioStreamingWithStartBlock:(SDLStreamingLifecycleBlock)startBlock;
- (void)stopAudioSession;
- (BOOL)sendAudioData:(NSData *)pcmAudioData;

@end

NS_ASSUME_NONNULL_END
