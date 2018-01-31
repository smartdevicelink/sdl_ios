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

NS_ASSUME_NONNULL_BEGIN

@interface SDLAsynchronousRPCRequestOperation ()

@property (copy, nonatomic) NSArray<SDLRPCRequest *> *requests;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (assign, nonatomic, nullable) SDLMultipleRequestProgressHandler progressHandler;
@property (assign, nonatomic, nullable) SDLMultipleRequestCompletionHandler completionHandler;
@property (assign, nonatomic, nullable) SDLResponseHandler responseHandler;

@property (strong, nonatomic) NSUUID *operationId;
@property (assign, nonatomic) NSUInteger requestsComplete;
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

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager requests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    self = [self init];

    _requests = requests;
    _progressHandler = progressHandler;
    _completionHandler = completionHandler;

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager request:(SDLRPCRequest *)request responseHandler:(nullable SDLResponseHandler)responseHandler {
    self = [self init];

    executing = NO;
    finished = NO;

    _requests = @[request];

    return self;
}

- (void)start {
    [super start];

    [self sdl_sendRequests];
}

- (void)sdl_sendRequests {
    for (SDLRPCRequest *request in self.requests) {
        if (self.isCancelled) {
            if (self.completionHandler != NULL) {
                self.completionHandler(NO);
            }

            break;
        }

        [self sdl_sendRequest:request];
    }
}

- (void)sdl_sendRequest:(SDLRPCRequest *)request {
    [self.connectionManager sendConnectionRequest:request withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        self.requestsComplete++;
        // If this request failed and no request has yet failed, set our internal request failed to YES
        if (!self.requestFailed && error != nil) {
            self.requestFailed = YES;
        }

        if (self.progressHandler != NULL) {
            // If the user decided to cancel, cancel for our next go around.
            BOOL cancelled = self.progressHandler(request, response, error, self.percentComplete);
            if (cancelled) {
                [self cancel];
                return;
            }
        }

        // If we've received responses for all requests, call the completion handler.
        if (self.requestsComplete == self.requests.count) {
            if (self.completionHandler != NULL) {
                self.completionHandler(self.requestFailed);
            } else if (self.responseHandler != NULL) {
                self.responseHandler(request, response, error);
            }
        }
    }];
}

#pragma mark - Getters

- (float)percentComplete {
    return self.requestsComplete / self.requests.count;
}

#pragma mark - Property Overrides

- (nullable NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.operationId];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

@end

NS_ASSUME_NONNULL_END
