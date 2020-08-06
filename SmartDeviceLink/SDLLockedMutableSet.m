//
//  SDLLockedMutableSet.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/6/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLockedMutableSet.h"

@interface SDLLockedMutableSet ()

@property (assign, nonatomic) dispatch_queue_t internalQueue;
@property (assign, nonatomic) const char *internalQueueID;

@property (strong, nonatomic) NSMutableSet *internalSet;

@end

@implementation SDLLockedMutableSet

#pragma mark - Initializers

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (!self) { return nil; }

    _internalQueue = queue;
    _internalQueueID = [[NSUUID alloc] init].UUIDString.UTF8String;
    dispatch_queue_set_specific(_internalQueue, _internalQueueID, (void *)_internalQueueID, NULL);

    _internalSet = [[NSMutableSet alloc] init];

    return self;
}


#pragma mark - Getting / Setting

#pragma mark Retrieving information
- (NSUInteger)count {
    __block NSUInteger retVal = 0;
    [self sdl_runSyncWithBlock:^{
        retVal = self.internalSet.count;
    }];

    return retVal;
}

#pragma mark Adding Objects
- (void)addObject:(id)object {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf.internalSet addObject:object];
    }];
}

#pragma mark Modifications
- (void)unionSet:(NSMutableSet *)otherSet {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf.internalSet unionSet:otherSet];
    }];
}

# pragma mark - Utilities
- (void)sdl_runSyncWithBlock:(void (^)(void))block {
    if (dispatch_get_specific(_internalQueueID) != NULL) {
        block();
    } else {
        dispatch_sync(_internalQueue, block);
    }
}

- (void)sdl_runAsyncWithBlock:(void (^)(void))block {
    if (dispatch_get_specific(_internalQueueID) != NULL) {
        block();
    } else {
        dispatch_barrier_async(_internalQueue, block);
    }
}

@end
