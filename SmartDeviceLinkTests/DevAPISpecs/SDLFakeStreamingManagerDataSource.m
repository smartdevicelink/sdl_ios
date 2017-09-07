//
//  SDLFakeStreamingManagerDataSource.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 9/5/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLFakeStreamingManagerDataSource.h"

#import "SDLImageResolution.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingProtocol.h"

@implementation SDLFakeStreamingManagerDataSource

- (SDLVideoStreamingFormat *)extraFormat {
    return [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecVP8 protocol:SDLVideoStreamingProtocolRTMP];
}

- (NSArray<SDLVideoStreamingFormat *> *)preferredVideoFormatOrderFromHeadUnitPreferredOrder:(NSArray<SDLVideoStreamingFormat *> *)headUnitPreferredOrder {
    return [@[self.extraFormat] arrayByAddingObjectsFromArray:headUnitPreferredOrder];
}

- (NSArray<SDLImageResolution *> *)resolutionFromHeadUnitPreferredResolution:(SDLImageResolution *)headUnitPreferredResolution {
    return @[headUnitPreferredResolution];
}

@end
