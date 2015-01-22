//  SDLOnTBTClientState.m
//
// 

#import <SmartDeviceLink/SDLOnTBTClientState.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnTBTClientState

-(id) init {
    if (self = [super initWithName:NAMES_OnTBTClientState]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setState:(SDLTBTState*) state {
    if (state != nil) {
        [parameters setObject:state forKey:NAMES_state];
    } else {
        [parameters removeObjectForKey:NAMES_state];
    }
}

-(SDLTBTState*) state {
    NSObject* obj = [parameters objectForKey:NAMES_state];
    if ([obj isKindOfClass:SDLTBTState.class]) {
        return (SDLTBTState*)obj;
    } else {
        return [SDLTBTState valueOf:(NSString*)obj];
    }
}

@end
