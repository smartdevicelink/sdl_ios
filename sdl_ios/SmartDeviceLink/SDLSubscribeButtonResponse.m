//  SDLSubscribeButtonResponse.m
//
//  

#import <SmartDeviceLink/SDLSubscribeButtonResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSubscribeButtonResponse

-(id) init {
    if (self = [super initWithName:NAMES_SubscribeButton]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
