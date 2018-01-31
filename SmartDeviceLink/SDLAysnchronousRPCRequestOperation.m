//
//  SDLRPCRequestOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLAysnchronousRPCRequestOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLError.h"

@interface SDLAysnchronousRPCRequestOperation ()

@property (copy, nonatomic) NSArray<SDLRPCRequest *> *requests;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (assign, nonatomic, nullable) SDLMultipleRequestProgressHandler progressHandler;
@property (assign, nonatomic, nullable) SDLMultipleRequestCompletionHandler completionHandler;
@property (assign, nonatomic) BOOL sequential;

@property (assign, nonatomic) NSUInteger requestsComplete;
@property (assign, nonatomic, readonly) float percentComplete;
@property (assign, nonatomic) BOOL requestFailed;

@end

@implementation SDLAysnchronousRPCRequestOperation {
    BOOL executing;
    BOOL finished;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager requests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(SDLMultipleRequestProgressHandler)progressHandler completionHandler:(SDLMultipleRequestCompletionHandler)completionHandler {
    self = [super init];
    if (!self) { return nil; }

    executing = NO;
    finished = NO;

    _requests = requests;
    _progressHandler = progressHandler;
    _completionHandler = completionHandler;

    _requestsComplete = 0;

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

        [self sdl_sendRequest: request];
    }
}

- (void)sdl_sendRequest:(SDLRPCRequest *)request {
    [self.connectionManager sendManagerRequest:request withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        self.requestsComplete++;

        if (self.progressHandler != NULL) {
            BOOL cancelled = self.progressHandler(request, response, error, self.percentComplete);

            // If this request failed and no request has yet failed, set our internal request failed to YES
            if (!self.requestFailed && error != nil) {
                self.requestFailed = YES;
            }

            // If the user decided to cancel, cancel for our next go around.
            if (cancelled) {
                [self cancel];
                return;
            }
        }

        // If we've received responses for all requests, call the completion handler.
        if (self.requestsComplete == self.requests.count) {
            if (self.completionHandler != NULL) {
                self.completionHandler(self.requestFailed);
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
    return [NSString stringWithFormat:@"%@ RPC Sending – %lu RPCs", (self.sequential ? @"Sequential" : @"Non-Sequential"), self.requests.count];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

@end
