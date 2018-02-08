//
//  TestRequestProgressResponse.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/8/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "TestRequestProgressResponse.h"

@implementation TestRequestProgressResponse

- (instancetype)initWithCorrelationId:(NSNumber<SDLInt> *)correlationId percentComplete:(float)percentComplete error:(NSError *)error {
    self = [super init];
    if (!self) { return nil; }

    _correlationId = correlationId;
    _percentComplete = percentComplete;
    _error = error;

    return self;
}

@end
