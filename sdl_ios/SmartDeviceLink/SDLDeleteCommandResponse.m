//  SDLDeleteCommandResponse.m
//
//  

#import <SmartDeviceLink/SDLDeleteCommandResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDeleteCommandResponse

-(id) init {
    if (self = [super initWithName:NAMES_DeleteCommand]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
