//
//  TestConnectionManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/6/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "TestConnectionManager.h"

#import "SDLRPCRequest.h"
#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TestConnectionManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _receivedRequests = [NSMutableArray<__kindof SDLRPCMessage *> array];
    _multipleCompletionBlocks = [NSMutableArray array];

    return self;
}

- (void)sendConnectionRPC:(__kindof SDLRPCMessage *)rpc {
    [self.receivedRequests addObject:rpc];
}

- (void)sendConnectionRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    self.lastRequestBlock = handler;
    SDLRPCRequest *requestRPC = (SDLRPCRequest *)request;
    requestRPC.correlationID = [self test_nextCorrelationID];
    [self.receivedRequests addObject:requestRPC];
}

- (void)sendConnectionManagerRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [self sendConnectionRequest:request withResponseHandler:handler];
}

- (void)sendConnectionManagerRPC:(__kindof SDLRPCMessage *)rpc {
    [self sendConnectionRPC:rpc];
}

- (void)sendRequests:(nonnull NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    [requests enumerateObjectsUsingBlock:^(SDLRPCRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
        [self sendConnectionRequest:request withResponseHandler:nil];

        if (progressHandler != nil) {
            progressHandler(request, nil, nil, (double)idx / (double)requests.count);
        }
    }];

    [_multipleCompletionBlocks addObject:completionHandler];
}

- (void)sendSequentialRequests:(nonnull NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleSequentialRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    [requests enumerateObjectsUsingBlock:^(SDLRPCRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
        [self sendConnectionRequest:request withResponseHandler:nil];
        progressHandler(request, nil, nil, (double)idx / (double)requests.count);
    }];

    [_multipleCompletionBlocks addObject:completionHandler];
}

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response {
    [self respondToLastRequestWithResponse:response error:nil];
}

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response error:(nullable NSError *)error {
    NSError *thisError = nil;
    if (!response.success.boolValue && error == nil) {
        thisError = self.defaultError;
    } else if (error != nil) {
        thisError = error;
    }

    if (self.lastRequestBlock != nil) {
        self.lastRequestBlock(self.receivedRequests.lastObject, response, thisError);
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempted to respond to last request, but there was no last request block" userInfo:nil];
    }
}

- (void)respondToRequestWithResponse:(__kindof SDLRPCResponse *)response requestNumber:(NSInteger)requestNumber error:(nullable NSError *)error {
    NSError *thisError = nil;
    if (!response.success.boolValue && error == nil) {
        thisError = self.defaultError;
    } else if (error != nil) {
        thisError = error;
    }

    if (self.lastRequestBlock != nil) {
        self.lastRequestBlock(self.receivedRequests[requestNumber], response, thisError);
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempted to respond to last request, but there was no last request block" userInfo:nil];
    }
}

- (void)respondToLastMultipleRequestsWithSuccess:(BOOL)success {
    if (self.multipleCompletionBlocks.lastObject != nil) {
        SDLMultipleRequestCompletionHandler block = [self.multipleCompletionBlocks.lastObject copy];
        [self.multipleCompletionBlocks removeLastObject];
        block(success);
    }
}

- (void)reset {
    _receivedRequests = [NSMutableArray<__kindof SDLRPCMessage *> array];
    _lastRequestBlock = nil;
}


#pragma mark - Getters

- (NSError *)defaultError {
    return [NSError errorWithDomain:@"com.sdl.testConnectionManager" code:-1 userInfo:nil];
}

#pragma mark Private helpers

- (NSNumber *)test_nextCorrelationID {
    static NSUInteger correlationID = 0;
    
    return @(correlationID++);
}

@end

NS_ASSUME_NONNULL_END
