//  SDLSetGlobalPropertiesResponse.m
//
//  

#import <SmartDeviceLink/SDLSetGlobalPropertiesResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSetGlobalPropertiesResponse

-(id) init {
    if (self = [super initWithName:NAMES_SetGlobalProperties]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
