//  SDLTTSChunk.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLTTSChunk.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLTTSChunk

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setText:(NSString*) text {
    [store setOrRemoveObject:text forKey:NAMES_text];
}

-(NSString*) text {
    return [store objectForKey:NAMES_text];
}

-(void) setType:(SDLSpeechCapabilities*) type {
    [store setOrRemoveObject:type forKey:NAMES_type];
}

-(SDLSpeechCapabilities*) type {
    NSObject* obj = [store objectForKey:NAMES_type];
    if ([obj isKindOfClass:SDLSpeechCapabilities.class]) {
        return (SDLSpeechCapabilities*)obj;
    } else {
        return [SDLSpeechCapabilities valueOf:(NSString*)obj];
    }
}

@end
