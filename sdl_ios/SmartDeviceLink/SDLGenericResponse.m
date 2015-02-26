//  SDLGenericResponse.m
//
//  

#import <SmartDeviceLink/SDLGenericResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLGenericResponse

-(id) init {
    if (self = [super initWithName:NAMES_GenericResponse]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
