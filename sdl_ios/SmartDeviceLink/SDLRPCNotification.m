//  SDLRPCNotification.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLRPCNotification.h>

#import "SDLNames.h"

@implementation SDLRPCNotification

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (!self) {
        return nil;
    }
    
    messageType = NAMES_notification;
    
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }
    
    messageType = NAMES_notification;
    
    return self;
}

@end
