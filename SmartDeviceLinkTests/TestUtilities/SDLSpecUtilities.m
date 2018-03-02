//
//  SDLSpecUtilities.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/8/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSpecUtilities.h"

#import "NSNumber+NumberType.h"
#import "SDLAddCommandResponse.h"

#import "TestResponse.h"

@implementation SDLSpecUtilities

+ (TestResponse *)addCommandRPCResponseWithCorrelationId:(NSNumber<SDLInt> *)correlationId {
    SDLAddCommandResponse *response = [[SDLAddCommandResponse alloc] init];
    response.success = @YES;
    response.correlationID = correlationId;

    TestResponse *testResponse = [[TestResponse alloc] initWithResponse:response error:nil];

    return testResponse;
}

@end
