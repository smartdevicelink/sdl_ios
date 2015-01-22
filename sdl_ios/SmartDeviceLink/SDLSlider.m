//  SDLSlider.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSlider.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSlider

-(id) init {
    if (self = [super initWithName:NAMES_Slider]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setNumTicks:(NSNumber *)numTicks {
    [parameters setOrRemoveObject:numTicks forKey:NAMES_numTicks];
}

-(NSNumber*) numTicks {
    return [parameters objectForKey:NAMES_numTicks];
}

- (void)setPosition:(NSNumber *)position {
    [parameters setOrRemoveObject:position forKey:NAMES_position];
}

-(NSNumber*) position {
    return [parameters objectForKey:NAMES_position];
}

- (void)setSliderHeader:(NSString *)sliderHeader {
    [parameters setOrRemoveObject:sliderHeader forKey:NAMES_sliderHeader];
}

-(NSString*) sliderHeader {
    return [parameters objectForKey:NAMES_sliderHeader];
}

- (void)setSliderFooter:(NSMutableArray *)sliderFooter {
    [parameters setOrRemoveObject:sliderFooter forKey:NAMES_sliderFooter];
}

-(NSMutableArray*) sliderFooter {
    return [parameters objectForKey:NAMES_sliderFooter];
}

- (void)setTimeout:(NSNumber *)timeout {
    [parameters setOrRemoveObject:timeout forKey:NAMES_timeout];
}

-(NSNumber*) timeout {
    return [parameters objectForKey:NAMES_timeout];
}

@end
