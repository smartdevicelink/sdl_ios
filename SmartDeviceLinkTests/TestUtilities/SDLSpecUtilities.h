//
//  SDLSpecUtilities.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/8/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLAddCommandResponse;

@interface SDLSpecUtilities : NSObject

+ (SDLAddCommandResponse *)addCommandRPCResponseWithCorrelationId:(NSNumber<SDLInt>)correlationId;

@end
