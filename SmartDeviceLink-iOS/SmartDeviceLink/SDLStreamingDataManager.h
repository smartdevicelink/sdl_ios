//
//  SDLStreamingDataManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
@import VideoToolbox;

@class SDLAbstractProtocol;


NS_ENUM(NSUInteger, SDLStreamingDataType) {
    SDLStreamingDataTypeVideo,
    SDLStreamingDataTypePCMAudio
};

typedef void (^SDLStreamingStartBlock)(BOOL success);

/**
 *  This block is called when the data manager is ready for a new packet of video data to be encoded and sent to the head unit as part of an H.264 video strem
 *
 *  @return The CMSampleBufferRef that's going to be streamed as an H.264 stream
 */
typedef CMSampleBufferRef (^SDLStreamingVideoDataBlock)();

/**
 *  This block is called when the data manager is ready for a new packet of PCM audio data to be sent to the head unit.
 *
 *  @return The PCM audio data to be transferred to the head unit.
 */
typedef NSData * (^SDLStreamingAudioDataBlock)();


@interface SDLStreamingDataManager : NSObject

@property (assign, nonatomic) BOOL videoSessionConnected;
@property (assign, nonatomic) BOOL audioSessionConnected;

- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol;

- (void)startVideoSessionWithStartBlock:(SDLStreamingStartBlock)startBlock dataBlock:(SDLStreamingVideoDataBlock)dataBlock;
//- (void)stopVideoSession

- (void)startAudioStreamingWithStartBlock:(SDLStreamingStartBlock)startBlock dataBlock:(SDLStreamingVideoDataBlock)dataBlock;

@end
