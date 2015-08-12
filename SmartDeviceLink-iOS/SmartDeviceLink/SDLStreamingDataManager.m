//
//  SDLStreamingDataManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLStreamingDataManager.h"

#import "SDLAbstractProtocol.h"


@interface SDLStreamingDataManager ()

@property (weak, nonatomic) SDLAbstractProtocol *protocol;

@end


@implementation SDLStreamingDataManager

- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _protocol = protocol;
    
    return self;
}

- (void)startVideoSessionWithStartBlock:(SDLStreamingStartBlock)startBlock dataBlock:(SDLStreamingVideoDataBlock)dataBlock {
    [self.protocol sendStartSessionWithType:SDLServiceType_Video];
}

- (void)startAudioStreamingWithStartBlock:(SDLStreamingStartBlock)startBlock dataBlock:(SDLStreamingVideoDataBlock)dataBlock {
    [self.protocol sendStartSessionWithType:SDLServiceType_Audio];
}

@end
