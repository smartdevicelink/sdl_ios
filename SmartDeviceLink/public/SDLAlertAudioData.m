//
//  SDLAlertAudioData.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAlertAudioData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlertAudioData

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLAlertAudioData *new = [super copyWithZone:zone];
    new->_playTone = _playTone;
    return new;
}

@end

NS_ASSUME_NONNULL_END
