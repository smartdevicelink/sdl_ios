//
//  VideoStreamSettings.h
//  SmartDeviceLink-Example-ObjC
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import <Foundation/Foundation.h>

@class SDLSupportedStreamingRange;

NS_ASSUME_NONNULL_BEGIN

@interface VideoStreamSettings : NSObject
@property (nonatomic, copy) NSString * SDLVersion;
@property (strong, nonatomic, nullable) SDLSupportedStreamingRange *supportedLandscapeStreamingRange;
@property (strong, nonatomic, nullable) SDLSupportedStreamingRange *supportedPortraitStreamingRange;
- (NSString *)detailedDescription;
@end

NS_ASSUME_NONNULL_END
