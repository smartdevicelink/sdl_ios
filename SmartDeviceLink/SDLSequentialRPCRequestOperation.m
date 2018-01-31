//
//  SDLSequentialRPCRequestOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/31/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSequentialRPCRequestOperation.h"

#import "SDLConnectionManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSequentialRPCRequestOperation ()

@property (copy, nonatomic) NSArray<SDLRPCRequest *> *requests;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (assign, nonatomic, nullable) SDLMultipleRequestProgressHandler progressHandler;
@property (assign, nonatomic, nullable) SDLMultipleRequestCompletionHandler completionHandler;

@property (strong, nonatomic) NSUUID *operationId;
@property (assign, nonatomic) NSUInteger requestsComplete;
@property (assign, nonatomic) NSUInteger currentRequestIndex;
@property (assign, nonatomic, readonly) float percentComplete;
@property (assign, nonatomic) BOOL requestFailed;

@end

@implementation SDLSequentialRPCRequestOperation {
    BOOL executing;
    BOOL finished;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager requests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    self = [super init];
    if (!self) { return nil; }

    executing = NO;
    finished = NO;

    _requests = requests;
    _progressHandler = progressHandler;
    _completionHandler = completionHandler;

    _operationId = [NSUUID UUID];
    _requestsComplete = 0;

    return self;
}

- (void)start {
    [super start];

    [self sdl_sendNextRequest];
}

- (void)sdl_sendNextRequest {
    if (self.cancelled) {
        if (self.completionHandler != nil) {
            self.completionHandler(self.requestFailed);
        }

        return;
    }

    if (self.currentRequestIndex >= self.requests.count) {
        if (self.completionHandler != nil) {
            self.completionHandler(self.requestFailed);
        }

        [self finishOperation];
    }

    SDLRPCRequest *request = self.requests[self.currentRequestIndex];
    [self.connectionManager sendConnectionRequest:request withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        // If this request failed and no request has yet failed, set our internal request failed to YES
        if (!self.requestFailed && error != nil) {
            self.requestFailed = YES;
        }

        if (self.progressHandler != NULL) {
            BOOL cancelled = self.progressHandler(request, response, error, self.percentComplete);

            // If the user decided to cancel, cancel for our next go around.
            if (cancelled) {
                [self cancel];
                return;
            }
        }

        self.currentRequestIndex++;
        [self sdl_sendNextRequest];
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
