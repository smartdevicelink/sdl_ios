//
//  SDLRPCResponseOperation.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/20/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponseOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLError.h"
#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCResponseOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic) NSUUID *operationId;

@end

@implementation SDLRPCResponseOperation {
    BOOL executing;
    BOOL finished;
}

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    executing = NO;
    finished = NO;

    _operationId = [NSUUID UUID];

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager rpc:(__kindof SDLRPCMessage *)rpc {
    self = [self init];

    _rpc = rpc;
    _connectionManager = connectionManager;

    return self;
}

- (void)start {
    [super start];
    [self sdl_sendRPC:self.rpc];
}

- (void)sdl_sendRPC:(__kindof SDLRPCMessage *)rpc {
    if (self.isCancelled) {
        [self sdl_abortOperation];
        return;
    }

    [self.connectionManager sendConnectionRPC:rpc withResponseHandler:nil];
    [self finishOperation];
}

- (void)sdl_abortOperation {
    [self finishOperation];
}

#pragma mark - Property Overrides
- (nullable NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.operationId];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.name];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@, request type=%@", self.name, self.rpc.class];
}

@end

NS_ASSUME_NONNULL_END
