//  SDLSetMediaClockTimerResponse.m
//
// 

#import <SmartDeviceLink/SDLSetMediaClockTimerResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSetMediaClockTimerResponse

-(id) init {
    if (self = [super initWithName:NAMES_SetMediaClockTimer]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
