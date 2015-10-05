//
//  SDLErrorConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SDLManagerError) {
    SDLManagerErrorRPCRequestFailed = -1,
    SDLManagerErrorNotConnected = -2,
    SDLManagerErrorUnknownHeadUnitError = -3
};

#pragma mark Error Domains
extern NSString *const SDLManagerErrorDomain;

@interface SDLErrorConstants : NSObject

@end
