//
//  TestConnectionRequestObject.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 11/13/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "TestConnectionRequestObject.h"

@implementation TestConnectionRequestObject

- (instancetype)initWithMessage:(__kindof SDLRPCMessage *)message responseHandler:(SDLResponseHandler)handler {
    self = [super init];
    if (!self) { return nil; }

    _message = message;
    _responseHandler = handler;

    return self;
}

@end
