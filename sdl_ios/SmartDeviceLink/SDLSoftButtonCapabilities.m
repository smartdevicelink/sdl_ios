//  SDLSoftButtonCapabilities.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSoftButtonCapabilities.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSoftButtonCapabilities

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setShortPressAvailable:(NSNumber*) shortPressAvailable {
    [store setOrRemoveObject:shortPressAvailable forKey:NAMES_shortPressAvailable];
}

-(NSNumber*) shortPressAvailable {
    return [store objectForKey:NAMES_shortPressAvailable];
}

-(void) setLongPressAvailable:(NSNumber*) longPressAvailable {
    [store setOrRemoveObject:longPressAvailable forKey:NAMES_longPressAvailable];
}

-(NSNumber*) longPressAvailable {
    return [store objectForKey:NAMES_longPressAvailable];
}

-(void) setUpDownAvailable:(NSNumber*) upDownAvailable {
    [store setOrRemoveObject:upDownAvailable forKey:NAMES_upDownAvailable];
}

-(NSNumber*) upDownAvailable {
    return [store objectForKey:NAMES_upDownAvailable];
}

-(void) setImageSupported:(NSNumber*) imageSupported {
    [store setOrRemoveObject:imageSupported forKey:NAMES_imageSupported];
}

-(NSNumber*) imageSupported {
    return [store objectForKey:NAMES_imageSupported];
}

@end
