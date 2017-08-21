//
//  TestResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/17/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TestResponse.h"

@implementation TestResponse

- (instancetype)initWithResponse:(SDLRPCResponse *)testResponse error:(NSError *)testError {
    self = [super init];
    if (!self) {
        return nil;
    }

    _testResponse = testResponse;
    _testError = testError;

    return self;
}

@end
