//
//  SDLVideoStreamingCodec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLVideoStreamingCodec.h"

SDLVideoStreamingCodec *SDLVideoStreamingCodec_H264 = nil;
SDLVideoStreamingCodec *SDLVideoStreamingCodec_H265 = nil;
SDLVideoStreamingCodec *SDLVideoStreamingCodec_THEORA = nil;
SDLVideoStreamingCodec *SDLVideoStreamingCodec_VP8 = nil;
SDLVideoStreamingCodec *SDLVideoStreamingCodec_VP9 = nil;

NSArray *SDLVideoStreamingCodec_values = nil;

@implementation SDLVideoStreamingCodec

+ (SDLVideoStreamingCodec *)valueOf:(NSString *)value {
    for (SDLVideoStreamingCodec *item in SDLVideoStreamingCodec.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLVideoStreamingCodec_values == nil) {
        SDLVideoStreamingCodec_values = @[
                                          SDLVideoStreamingCodec.H264,
                                          SDLVideoStreamingCodec.H265,
                                          SDLVideoStreamingCodec.THEORA,
                                          SDLVideoStreamingCodec.VP8,
                                          SDLVideoStreamingCodec.VP9
                                          ];
    }
    return SDLVideoStreamingCodec_values;
}

+ (SDLVideoStreamingCodec *)H264 {
    if (SDLVideoStreamingCodec_H264 == nil) {
        SDLVideoStreamingCodec_H264 = [[SDLVideoStreamingCodec alloc] initWithValue:@"H264"];
    }
    return SDLVideoStreamingCodec_H264;
}

+ (SDLVideoStreamingCodec *)H265 {
    if (SDLVideoStreamingCodec_H265 == nil) {
        SDLVideoStreamingCodec_H265 = [[SDLVideoStreamingCodec alloc] initWithValue:@"H265"];
    }
    return SDLVideoStreamingCodec_H265;
}

+ (SDLVideoStreamingCodec *)THEORA {
    if (SDLVideoStreamingCodec_THEORA == nil) {
        SDLVideoStreamingCodec_THEORA = [[SDLVideoStreamingCodec alloc] initWithValue:@"THEORA"];
    }
    return SDLVideoStreamingCodec_THEORA;
}

+ (SDLVideoStreamingCodec *)VP8 {
    if (SDLVideoStreamingCodec_VP8 == nil) {
        SDLVideoStreamingCodec_VP8 = [[SDLVideoStreamingCodec alloc] initWithValue:@"VP8"];
    }
    return SDLVideoStreamingCodec_VP8;
}

+ (SDLVideoStreamingCodec *)VP9 {
    if (SDLVideoStreamingCodec_VP9 == nil) {
        SDLVideoStreamingCodec_VP9 = [[SDLVideoStreamingCodec alloc] initWithValue:@"VP9"];
    }
    return SDLVideoStreamingCodec_VP9;
}

@end
