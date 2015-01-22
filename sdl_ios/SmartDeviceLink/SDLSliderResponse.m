//  SDLSliderResponse.m
//
//  

#import <SmartDeviceLink/SDLSliderResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSliderResponse

-(id) init {
    if (self = [super initWithName:NAMES_Slider]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setSliderPosition:(NSNumber*) sliderPosition {
    if (sliderPosition != nil) {
        [parameters setObject:sliderPosition forKey:NAMES_sliderPosition];
    } else {
        [parameters removeObjectForKey:NAMES_sliderPosition];
    }
}

-(NSNumber*) sliderPosition {
    return [parameters objectForKey:NAMES_sliderPosition];
}

@end
