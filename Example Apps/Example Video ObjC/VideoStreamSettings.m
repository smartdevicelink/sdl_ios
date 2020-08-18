//
//  VideoStreamSettings.m
//  SmartDeviceLink-Example-ObjC
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import "VideoStreamSettings.h"
#import "SDLSupportedStreamingRange.h"

@implementation VideoStreamSettings

- (NSString *)detailedDescription {
    return [NSString stringWithFormat:@"SDLVersion: %@\nsupportedLandscapeStreamingRange: %@\nsupportedPortraitStreamingRange: %@", self.SDLVersion, self.supportedLandscapeStreamingRange, self.supportedPortraitStreamingRange];
}

@end
