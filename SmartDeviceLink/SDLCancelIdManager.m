//
//  SDLCancelIdManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/30/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLCancelIdManager.h"
#import "SDLGlobals.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLCancelIdManager()

@property (copy, nonatomic) dispatch_queue_t readWriteQueue;
@property (assign, nonatomic) UInt16 nextCancelId;

@end

UInt16 const CancelIdMin = 1;

@implementation SDLCancelIdManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _readWriteQueue = dispatch_queue_create_with_target("com.sdl.cancelIdManagers.readWriteQueue", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);
    _nextCancelId = CancelIdMin;
    return self;
}

- (void)stop {
    _nextCancelId = CancelIdMin;
}

- (UInt16)nextCancelId {
    __block UInt16 cancelId = 0;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        cancelId = self->_nextCancelId;
        self->_nextCancelId = cancelId + 1;
    }];

    return cancelId;
}

@end

NS_ASSUME_NONNULL_END
