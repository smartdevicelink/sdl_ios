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

- (void)startAudioStreamingWithStartBlock:(SDLStreamingLifecycleBlock)startBlock;
- (void)stopAudioSession;

@end

NS_ASSUME_NONNULL_END
