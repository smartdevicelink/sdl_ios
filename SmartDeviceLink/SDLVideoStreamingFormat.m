//
//  SDLVideoStreamingFormat.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/31/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLVideoStreamingFormat.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVideoStreamingFormat

- (SDLVideoStreamingProtocol)protocol {
    return [store sdl_objectForName:SDLNameVideoProtocol];
}

- (void)setVideoStreamingProtocol:(SDLVideoStreamingProtocol)protocol {
    [store sdl_setObject:protocol forName:SDLNameVideoProtocol];
}

- (SDLVideoStreamingCodec)codec {
    return [store sdl_objectForName:SDLNameVideoCodec];
}

- (void)setVideoStreamingCodec:(SDLVideoStreamingCodec)codec {
    [store sdl_setObject:codec forName:SDLNameVideoCodec];
}

@end

NS_ASSUME_NONNULL_END
