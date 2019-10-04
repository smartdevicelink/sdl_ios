//
//  SDLRPCRequestOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousRPCRequestOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLError.h"
#import "SDLGlobals.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAsynchronousRPCRequestOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic, nullable) SDLMultipleAsyncRequestProgressHandler progressHandler;
@property (copy, nonatomic, nullable) SDLMultipleRequestCompletionHandler completionHandler;
@property (copy, nonatomic, nullable) SDLResponseHandler responseHandler;

@property (strong, nonatomic) NSUUID *operationId;
@property (assign, nonatomic) NSUInteger requestsComplete;
@property (assign, nonatomic) NSUInteger requestsStarted;
@property (assign, nonatomic, readonly) float percentComplete;
@property (assign, nonatomic) BOOL requestFailed;

@end

@implementation SDLAsynchronousRPCRequestOperation {
    BOOL executing;
    BOOL finished;
}

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    executing = NO;
    finished = NO;

    _operationId = [NSUUID UUID];
    _requestsComplete = 0;
    _requestsStarted = 0;
    _requestFailed = NO;

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager requests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    self = [self init];

    _connectionManager = connectionManager;
    _requests = requests;
    _progressHandler = progressHandler;
    _completionHandler = completionHandler;

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager request:(SDLRPCRequest *)request responseHandler:(nullable SDLResponseHandler)responseHandler {
    self = [self init];

    _connectionManager = connectionManager;
    _requests = @[request];
    _responseHandler = responseHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    [self sdl_sendRequests];
}

- (void)sdl_sendRequests {
    for (SDLRPCRequest *request in self.requests) {
        if (self.isCancelled) {
            [self sdl_abortOperationWithRequest:request];
            return;
        }

        [self sdl_sendRequest:request];
        self.requestsStarted++;
    }
}

- (void)sdl_sendRequest:(SDLRPCRequest *)request {
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendConnectionRequest:request withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (weakSelf == nil) { return; }

        if (weakSelf.isCancelled) {
            [weakSelf sdl_abortOperationWithRequest:request];
            BLOCK_RETURN;
        }

        weakSelf.requestsComplete++;

        // If this request failed set our internal request failed to YES
        if (error != nil) {
            weakSelf.requestFailed = YES;
        }

        if (weakSelf.progressHandler != NULL) {
            float percentComplete = weakSelf.percentComplete;
            weakSelf.progressHandler(request, response, error, percentComplete);
        } else if (weakSelf.responseHandler != NULL) {
            weakSelf.responseHandler(request, response, error);
        }

        // If we've received responses for all requests, call the completion handler.
        if (weakSelf.requestsComplete >= weakSelf.requests.count) {
            [weakSelf finishOperation];
        }
    }];
}

- (void)sdl_abortOperationWithRequest:(SDLRPCRequest *)request {
    self.requestFailed = YES;

    for (NSUInteger i = self.requestsComplete; i < self.requests.count; i++) {
        if (self.progressHandler != NULL) {
            self.progressHandler(self.requests[i], nil, [NSError sdl_lifecycle_multipleRequestsCancelled], self.percentComplete);
        }

        if (self.responseHandler != NULL) {
            self.responseHandler(request, nil, [NSError sdl_lifecycle_multipleRequestsCancelled]);
        }

        if (self.completionHandler != NULL) {
            self.completionHandler(NO);
        }
    }

    [self finishOperation];
}

#pragma mark - Getters

- (float)percentComplete {
    return (float)self.requestsComplete / (float)self.requests.count;
}

#pragma mark - Property Overrides

- (void)finishOperation {
    if (self.completionHandler != NULL) {
        self.completionHandler(!self.requestFailed);
    }

    [super finishOperation];
}

- (nullable NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.operationId];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, request count=%lu, requests started=%lu, finished=%lu, failed=%@", self.name, (unsigned long)self.requests.count, (unsigned long)self.requestsStarted, (unsigned long)self.requestsComplete, (self.requestFailed ? @"YES": @"NO")];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@, request count=%lu, requests started=%lu, finished=%lu, failed=%@, requests=%@", self.name, (unsigned long)self.requests.count, (unsigned long)self.requestsStarted, (unsigned long)self.requestsComplete, (self.requestFailed ? @"YES": @"NO"), self.requests];
}

@end

NS_ASSUME_NONNULL_END
