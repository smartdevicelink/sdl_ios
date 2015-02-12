//  SDLRPCNotification.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

@interface SDLRPCNotification : SDLRPCMessage {}

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
