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

@protocol SDLAudioStreamManagerDelegate <NSObject>

@required
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager fileDidFinishPlaying:(NSURL *)fileURL successfully:(BOOL)successfully;
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager errorDidOccurForFile:(NSURL *)fileURL error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
