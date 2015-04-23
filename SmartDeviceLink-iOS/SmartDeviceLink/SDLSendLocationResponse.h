//
//  SDLSendLocationResponse.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 4/2/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <SmartDeviceLink/SmartDeviceLink.h>

@interface SDLSendLocationResponse : SDLRPCResponse

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
