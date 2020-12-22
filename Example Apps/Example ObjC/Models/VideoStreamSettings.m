//
//  VideoStreamSettings.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Leonid Lokhmatov on 7/28/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import "VideoStreamSettings.h"
#import "SDLSupportedStreamingRange.h"

@implementation VideoStreamSettings

- (NSString *)detailedDescription {
    return [NSString stringWithFormat:@"SDLVersion: %@\nsupportedLandscapeStreamingRange: %@\nsupportedPortraitStreamingRange: %@", self.SDLVersion, self.supportedLandscapeStreamingRange, self.supportedPortraitStreamingRange];
}

@end
