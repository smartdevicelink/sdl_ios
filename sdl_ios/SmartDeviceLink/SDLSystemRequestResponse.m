//  SDLSystemRequestResponse.m
//
//  

#import <SmartDeviceLink/SDLSystemRequestResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSystemRequestResponse

-(id) init {
    if (self = [super initWithName:NAMES_SystemRequest]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
