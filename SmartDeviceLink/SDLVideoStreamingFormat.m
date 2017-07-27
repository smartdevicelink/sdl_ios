//
//  SDLVideoStreamingFormat.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLNames.h"
#import "SDLVideoStreamingFormat.h"

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
    return store[NAMES_videoProtocol];
}

- (void)setVideoStreamingCodec:(SDLVideoStreamingCodec *)codec {
    if (codec != nil) {
        [store setObject:codec forKey:NAMES_videoCodec];
    } else {
        [store removeObjectForKey:NAMES_videoCodec];
    }
}

- (SDLVideoStreamingCodec *)codec {
    return store[NAMES_videoCodec];
}

@end
