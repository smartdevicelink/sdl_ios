//
//  SDLVideoStreamingProtocol.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLVideoStreamingProtocol.h"

SDLVideoStreamingProtocol *SDLVideoStreamingProtocol_RAW = nil;
SDLVideoStreamingProtocol *SDLVideoStreamingProtocol_RTP = nil;
SDLVideoStreamingProtocol *SDLVideoStreamingProtocol_RTSP = nil;
SDLVideoStreamingProtocol *SDLVideoStreamingProtocol_RTMP = nil;
SDLVideoStreamingProtocol *SDLVideoStreamingProtocol_WEBM = nil;

NSArray *SDLVideoStreamingProtocol_values = nil;

@implementation SDLVideoStreamingProtocol

+ (SDLVideoStreamingProtocol *)valueOf:(NSString *)value {
    for (SDLVideoStreamingProtocol *item in SDLVideoStreamingProtocol.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLVideoStreamingProtocol_values == nil) {
        SDLVideoStreamingProtocol_values = @[
                                          SDLVideoStreamingProtocol.RAW,
                                          SDLVideoStreamingProtocol.RTP,
                                          SDLVideoStreamingProtocol.RTSP,
                                          SDLVideoStreamingProtocol.RTMP,
                                          SDLVideoStreamingProtocol.WEBM
                                          ];
    }
    return SDLVideoStreamingProtocol_values;
}

+ (SDLVideoStreamingProtocol *)RAW {
    if (SDLVideoStreamingProtocol_RAW == nil) {
        SDLVideoStreamingProtocol_RAW = [[SDLVideoStreamingProtocol alloc] initWithValue:@"RAW"];
    }
    return SDLVideoStreamingProtocol_RAW;
}

+ (SDLVideoStreamingProtocol *)RTP {
    if (SDLVideoStreamingProtocol_RTP == nil) {
        SDLVideoStreamingProtocol_RTP = [[SDLVideoStreamingProtocol alloc] initWithValue:@"RTP"];
    }
    return SDLVideoStreamingProtocol_RTP;
}

+ (SDLVideoStreamingProtocol *)RTSP {
    if (SDLVideoStreamingProtocol_RTSP == nil) {
        SDLVideoStreamingProtocol_RTSP = [[SDLVideoStreamingProtocol alloc] initWithValue:@"RTSP"];
    }
    return SDLVideoStreamingProtocol_RTSP;
}

+ (SDLVideoStreamingProtocol *)RTMP {
    if (SDLVideoStreamingProtocol_RTMP == nil) {
        SDLVideoStreamingProtocol_RTMP = [[SDLVideoStreamingProtocol alloc] initWithValue:@"RTMP"];
    }
    return SDLVideoStreamingProtocol_RTMP;
}

+ (SDLVideoStreamingProtocol *)WEBM {
    if (SDLVideoStreamingProtocol_WEBM == nil) {
        SDLVideoStreamingProtocol_WEBM = [[SDLVideoStreamingProtocol alloc] initWithValue:@"WEBM"];
    }
    return SDLVideoStreamingProtocol_WEBM;
}

@end
