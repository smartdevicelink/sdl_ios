//
//  SDLAsychronousOperation.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousOperation.h"

#import "SDLLogMacros.h"

@implementation SDLAsynchronousOperation {
    BOOL executing;
    BOOL finished;
}

- (void)start {
    SDLLogV(@"Starting operation: %@", self);

    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        SDLLogV(@"Operation was cancelled: %@", self);

        return;
    }

    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)finishOperation {
    SDLLogV(@"Finishing Operation: %@", self);
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];

    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark - Property Overrides

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

@end
