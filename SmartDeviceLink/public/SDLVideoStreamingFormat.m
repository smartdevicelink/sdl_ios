//
//  SDLVideoStreamingFormat.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/31/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLVideoStreamingFormat.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVideoStreamingFormat

- (instancetype)initWithCodec:(SDLVideoStreamingCodec)codec protocol:(SDLVideoStreamingProtocol)protocol {
    self = [self init];
    if (!self) { return nil; }

    self.codec = codec;
    self.protocol = protocol;

    return self;
}

- (SDLVideoStreamingProtocol)protocol {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameVideoProtocol error:&error];
}

- (void)setProtocol:(SDLVideoStreamingProtocol)protocol {
    [self.store sdl_setObject:protocol forName:SDLRPCParameterNameVideoProtocol];
}

- (SDLVideoStreamingCodec)codec {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameVideoCodec error:&error];
}

- (void)setCodec:(SDLVideoStreamingCodec)codec {
    [self.store sdl_setObject:codec forName:SDLRPCParameterNameVideoCodec];
}

@end

NS_ASSUME_NONNULL_END
