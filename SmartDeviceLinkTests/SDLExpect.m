//
//  SDLExpect.m
//  SmartDeviceLinkTests
//
//  Created by Frank Elias on 6/13/23.
//  Copyright © 2023 smartdevicelink. All rights reserved.
//

#import "SDLExpect.h"

@implementation SDLExpect

+ (void)SDLExpectWithTimeout:(NSTimeInterval)timeout expectBlock:(nonnull ExpectBlock)expectBlock {
    [NSTimer scheduledTimerWithTimeInterval:timeout repeats:NO block:^(NSTimer * _Nonnull timer) {
        expectBlock();
    }];
}

+ (BOOL)getVerifiedVal:(BOOL)value {
    usleep(10);
    return value;
}

+ (int) timeout { return 3; }

@end
