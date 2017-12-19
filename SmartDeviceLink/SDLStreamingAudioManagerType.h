//
//  SDLStreamingAudioManagerType.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 12/5/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLStreamingAudioManagerType <NSObject>

@property (assign, nonatomic, readonly, getter=isAudioConnected) BOOL audioConnected;

- (BOOL)sendAudioData:(NSData *)audioData;

@end
