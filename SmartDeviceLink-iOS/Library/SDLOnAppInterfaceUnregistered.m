//  SDLOnAppInterfaceUnregistered.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLOnAppInterfaceUnregistered.h"

#import "SDLNames.h"

@implementation SDLOnAppInterfaceUnregistered

-(id) init {
    if (self = [super initWithName:NAMES_OnAppInterfaceUnregistered]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setReason:(SDLAppInterfaceUnregisteredReason*) reason {
    if (reason != nil) {
        [parameters setObject:reason forKey:NAMES_reason];
    } else {
        [parameters removeObjectForKey:NAMES_reason];
    }
}

-(SDLAppInterfaceUnregisteredReason*) reason {
    NSObject* obj = [parameters objectForKey:NAMES_reason];
    if ([obj isKindOfClass:SDLAppInterfaceUnregisteredReason.class]) {
        return (SDLAppInterfaceUnregisteredReason*)obj;
    } else {
        return [SDLAppInterfaceUnregisteredReason valueOf:(NSString*)obj];
    }
}

@end
