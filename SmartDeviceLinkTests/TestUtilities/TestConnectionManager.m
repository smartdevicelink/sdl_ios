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

    _receivedRequestObjects = [NSMutableArray<TestConnectionRequestObject *> array];
    _multipleCompletionBlocks = [NSMutableArray array];
    _systemInfo = [[SDLSystemInfo alloc] initWithMake:@"Livio" model:@"Is" trim:@"Awesome" modelYear:@"2021" softwareVersion:@"1.1.1.1" hardwareVersion:@"2.2.2.2"];

    return self;
}

- (NSArray<__kindof SDLRPCMessage *> *)receivedRequests {
    NSMutableArray<__kindof SDLRPCMessage *> *requests = [NSMutableArray array];
    [_receivedRequestObjects enumerateObjectsUsingBlock:^(__kindof TestConnectionRequestObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [requests addObject:obj.message];
    }];

    return [requests copy];
}

- (void)sendConnectionRPC:(__kindof SDLRPCMessage *)rpc {
    [self.receivedRequestObjects addObject:[[TestConnectionRequestObject alloc] initWithMessage:rpc responseHandler:nil]];
}

- (void)sendConnectionRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    request.correlationID = [self test_nextCorrelationID];
    [self.receivedRequestObjects addObject:[[TestConnectionRequestObject alloc] initWithMessage:request responseHandler:handler]];
}

- (void)sendConnectionManagerRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [self sendConnectionRequest:request withResponseHandler:handler];
}

- (void)sendConnectionManagerRPC:(__kindof SDLRPCMessage *)rpc {
    [self sendConnectionRPC:rpc];
}

- (void)sendRequests:(nonnull NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    if (requests.count == 0) {
        return completionHandler(YES);
    }

    [requests enumerateObjectsUsingBlock:^(SDLRPCRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
        [self sendConnectionRequest:request withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (progressHandler != nil) {
                progressHandler(request, response, error, (double)idx / (double)requests.count);
            }
        }];
    }];

    [_multipleCompletionBlocks addObject:completionHandler];
}

- (void)sendSequentialRequests:(nonnull NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleSequentialRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    if (requests.count == 0) {
        return completionHandler(YES);
    }

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

    TestConnectionRequestObject *lastObject = self.receivedRequestObjects.lastObject;
    if (lastObject.responseHandler != nil) {
        lastObject.responseHandler((SDLRPCRequest *)lastObject.message, response, thisError);
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

    TestConnectionRequestObject *requestObj = self.receivedRequestObjects[requestNumber];
    if (requestObj.responseHandler != nil) {
        requestObj.responseHandler((SDLRPCRequest *)requestObj.message, response, thisError);
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
    _receivedRequestObjects = [NSMutableArray<__kindof TestConnectionRequestObject *> array];
    _multipleCompletionBlocks = [NSMutableArray array];
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
