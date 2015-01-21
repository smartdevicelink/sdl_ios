//  SDLSetAppIcon.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSetAppIcon.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSetAppIcon

-(id) init {
    if (self = [super initWithName:NAMES_SetAppIcon]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setSyncFileName:(NSString *)syncFileName {
    [parameters setOrRemoveObject:syncFileName forKey:NAMES_syncFileName];
}

-(NSString*) syncFileName {
    return [parameters objectForKey:NAMES_syncFileName];
}

@end
