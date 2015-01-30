//  SDLPresetBankCapabilities.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLPresetBankCapabilities.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLPresetBankCapabilities

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setOnScreenPresetsAvailable:(NSNumber*) onScreenPresetsAvailable {
    [store setOrRemoveObject:onScreenPresetsAvailable forKey:NAMES_onScreenPresetsAvailable];
}

-(NSNumber*) onScreenPresetsAvailable {
    return [store objectForKey:NAMES_onScreenPresetsAvailable];
}

@end
