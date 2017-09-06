//
//  SDLFakeStreamingManagerDataSource.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 9/5/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLFakeStreamingManagerDataSource.h"

@implementation SDLFakeStreamingManagerDataSource

- (NSArray<SDLVideoStreamingFormat *> *)preferredVideoFormatOrderFromHeadUnitPreferredOrder:(NSArray<SDLVideoStreamingFormat *> *)headUnitPreferredOrder {
    return @[];
}

- (NSArray<SDLImageResolution *> *)resolutionFromHeadUnitPreferredResolution:(SDLImageResolution *)headUnitPreferredResolution {
    return @[];
}

@end
