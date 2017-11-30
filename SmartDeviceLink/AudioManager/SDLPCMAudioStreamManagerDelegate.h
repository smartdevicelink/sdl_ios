//
//  SDLBinaryAudioQueueDelegate.h
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLAudioFile;
@class SDLAudioStreamManager;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLPCMAudioStreamManagerDelegate <NSObject>

- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager fileDidFinishPlaying:(SDLAudioFile *)file successfully:(BOOL)successfully;
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager errorDidOccurForFile:(SDLAudioFile *)file error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
