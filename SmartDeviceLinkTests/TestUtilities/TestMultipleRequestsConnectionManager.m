//
//  TestMultipleRequestsConnectionManager.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/8/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "TestMultipleRequestsConnectionManager.h"

#import "SDLAddCommand.h"
#import "SDLAddCommandResponse.h"
#import "SDLNames.h"
#import "TestResponse.h"

@implementation TestMultipleRequestsConnectionManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _responses = [[NSMutableDictionary alloc] init];

    return self;
}

- (void)sendConnectionRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(SDLResponseHandler)handler {
    [super sendConnectionRequest:request withResponseHandler:handler];

    NSAssert([request.name isEqualToString:SDLNameAddCommand], @"The TestMultipleRequestsConnectionManager is only setup for SDLAddCommand");

    SDLAddCommand *addCommand = (SDLAddCommand *)request;
    TestResponse *response = self.responses[addCommand.correlationID];

    if (response == nil || handler == nil) { return; }
    handler(request, response.testResponse, response.testError);
}

@end
