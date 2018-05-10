//
//  AudioManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLManager;

NS_ASSUME_NONNULL_BEGIN

@interface AudioManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithManager:(SDLManager *)manager;
- (void)stopManager;

- (void)startRecording;
- (void)stopRecording;

@end

NS_ASSUME_NONNULL_END
