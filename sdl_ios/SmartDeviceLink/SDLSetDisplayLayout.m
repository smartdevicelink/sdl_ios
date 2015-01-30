//  SDLSetDisplayLayout.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSetDisplayLayout.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSetDisplayLayout

-(id) init {
    if (self = [super initWithName:NAMES_SetDisplayLayout]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setDisplayLayout:(NSString *)displayLayout {
    [parameters setOrRemoveObject:displayLayout forKey:NAMES_displayLayout];
}

-(NSString*) displayLayout {
    return [parameters objectForKey:NAMES_displayLayout];
}

@end
