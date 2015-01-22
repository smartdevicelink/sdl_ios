//  SDLSliderResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

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

- (void)setSliderPosition:(NSNumber *)sliderPosition {
    [parameters setOrRemoveObject:sliderPosition forKey:NAMES_sliderPosition];
}

-(NSNumber*) sliderPosition {
    return [parameters objectForKey:NAMES_sliderPosition];
}

@end
