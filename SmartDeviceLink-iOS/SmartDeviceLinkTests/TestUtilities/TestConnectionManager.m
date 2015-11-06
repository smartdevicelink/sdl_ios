//
//  TestConnectionManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/6/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "TestConnectionManager.h"

@implementation TestConnectionManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _receivedRequests = [NSMutableArray<__kindof SDLRPCRequest *> array];
    
    return self;
}

- (void)sendRequest:(__kindof SDLRPCRequest *)request withCompletionHandler:(SDLRequestCompletionHandler)block {
    [self.receivedRequests addObject:request];
    self.lastRequestBlock = block;
}

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response {
    self.lastRequestBlock(self.receivedRequests.lastObject, response, nil);
}

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response error:(NSError *)error {
    self.lastRequestBlock(self.receivedRequests.lastObject, response, error);
}

@end
