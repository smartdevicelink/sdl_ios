//
//  TestConnectionManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/6/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "TestConnectionManager.h"

#import "SDLRPCRequest.h"


NS_ASSUME_NONNULL_BEGIN

@implementation TestConnectionManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _receivedRequests = [NSMutableArray<__kindof SDLRPCRequest *> array];
    _fileUploadsRequestBlocks = [NSMutableArray<SDLResponseHandler> array];

    return self;
}

- (void)sendManagerRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    self.lastRequestBlock = handler;
    if ([request.name isEqualToString:@"PutFile"]) {
        [self.fileUploadsRequestBlocks addObject:handler];
    }

    request.correlationID = [self test_nextCorrelationID];
    
    [self.receivedRequests addObject:request];
}

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response {
    [self respondToLastRequestWithResponse:response error:nil];
}

- (void)respondToMultipleRequestWithResponse:(__kindof SDLRPCResponse *)response requestNumber:(NSInteger)requestNumber error:(NSError *_Nullable)error {
    SDLResponseHandler handler = [self.fileUploadsRequestBlocks objectAtIndex:requestNumber];
    if (handler != nil) {
        handler([[self receivedRequests] objectAtIndex:requestNumber], response, error);
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempted to respond to last request, but there was no last request block" userInfo:nil];
    }
}

- (void)respondToRequestWithResponse:(__kindof SDLRPCResponse *)response requestNumber:(NSInteger)requestNumber error:(NSError *_Nullable)error {
    if (self.lastRequestBlock != nil) {
        self.lastRequestBlock([[self receivedRequests] objectAtIndex:requestNumber], response, error);
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempted to respond to last request, but there was no last request block" userInfo:nil];
    }
}

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *_Nullable)response error:(NSError *_Nullable)error {
    if (self.lastRequestBlock != nil) {
        self.lastRequestBlock(self.receivedRequests.lastObject, response, error);
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempted to respond to last request, but there was no last request block" userInfo:nil];
    }
}

- (void)respondToRequestWithResponse:(__kindof SDLRPCResponse *)response request:(SDLRPCRequest *)request error:(NSError *_Nullable)error {
    if (self.lastRequestBlock != nil) {

    } else {

    }
}

- (void)reset {
    _receivedRequests = [NSMutableArray<__kindof SDLRPCRequest *> array];
    _lastRequestBlock = nil;
}


#pragma mark Private helpers

- (NSNumber *)test_nextCorrelationID {
    static NSUInteger correlationID = 0;
    
    return @(correlationID++);
}

@end

NS_ASSUME_NONNULL_END
