//
//  SDLAlertAudioData.h
//  SmartDeviceLink
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAudioData.h"

NS_ASSUME_NONNULL_BEGIN

/// Audio data for an SDLAlertView
@interface SDLAlertAudioData : SDLAudioData

/// Whether the alert tone should be played before the prompt (if any) is spoken. Defaults to NO.
@property (assign, nonatomic) BOOL playTone;

/// Use another init instead. See superclass SDLAudioData.
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
