//
//  SDLVideoStreamingFormat.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLNames.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingProtocol.h"

@implementation SDLVideoStreamingFormat

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setVideoStreamingProtocol:(SDLVideoStreamingProtocol *)protocol {
    if (protocol != nil) {
        [store setObject:protocol forKey:NAMES_videoProtocol];
    } else {
        [store removeObjectForKey:NAMES_videoProtocol];
    }
}

- (SDLVideoStreamingProtocol *)protocol {
    NSObject *obj = [store objectForKey:NAMES_videoProtocol];
    if (obj == nil || [obj isKindOfClass:SDLVideoStreamingProtocol.class]) {
        return (SDLVideoStreamingProtocol *)obj;
    } else {
        return [SDLVideoStreamingProtocol valueOf:(NSString *)obj];
    }
}

- (void)setVideoStreamingCodec:(SDLVideoStreamingCodec *)codec {
    if (codec != nil) {
        [store setObject:codec forKey:NAMES_videoCodec];
    } else {
        [store removeObjectForKey:NAMES_videoCodec];
    }
}

- (SDLVideoStreamingCodec *)codec {
    NSObject *obj = [store objectForKey:NAMES_videoCodec];
    if (obj == nil || [obj isKindOfClass:SDLVideoStreamingCodec.class]) {
        return (SDLVideoStreamingCodec *)obj;
    } else {
        return [SDLVideoStreamingCodec valueOf:(NSString *)obj];
    }
}

@end
