//  SDLImageResolution.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLImageResolution.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLImageResolution

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setResolutionWidth:(NSNumber*) resolutionWidth {
    [store setOrRemoveObject:resolutionWidth forKey:NAMES_resolutionWidth];
}

-(NSNumber*) resolutionWidth {
    return [store objectForKey:NAMES_resolutionWidth];
}

-(void) setResolutionHeight:(NSNumber*) resolutionHeight {
    [store setOrRemoveObject:resolutionHeight forKey:NAMES_resolutionHeight];
}

-(NSNumber*) resolutionHeight {
    return [store objectForKey:NAMES_resolutionHeight];
}

@end
