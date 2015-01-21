//  SDLRPCNotification.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

@interface SDLRPCNotification : SDLRPCMessage {}

- (id)initWithName:(NSString *)name;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@end
