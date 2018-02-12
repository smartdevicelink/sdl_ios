//
//  SDLSpecUtilities.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/8/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

@class SDLAddCommandResponse;
@class TestResponse;

@interface SDLSpecUtilities : NSObject

+ (TestResponse *)addCommandRPCResponseWithCorrelationId:(NSNumber<SDLInt> *)correlationId;

@end
