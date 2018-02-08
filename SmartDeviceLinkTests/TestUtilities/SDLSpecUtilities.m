//
//  SDLSpecUtilities.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/8/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSpecUtilities.h"

#import "SDLAddCommandResponse.h"

@implementation SDLSpecUtilities

+ (SDLAddCommandResponse *)addCommandRPCResponseWithCorrelationId:(NSNumber<SDLInt>)correlationId {
    SDLAddCommandResponse *response = [[SDLAddCommandResponse alloc] init];
    response.success = @YES;
    response.correlationID = correlationId;

    return response;
}

@end
