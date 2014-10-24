//  SDLRPCRequest.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

@interface SDLRPCRequest : SDLRPCMessage {}

@property(strong) NSNumber* correlationID;

@end
