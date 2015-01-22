//  SDLSystemRequest.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSystemRequest.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSystemRequest

-(id) init {
    if (self = [super initWithName:NAMES_SystemRequest]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setRequestType:(SDLRequestType *)requestType {
    [parameters setOrRemoveObject:requestType forKey:NAMES_requestType];
}

-(SDLRequestType*) requestType {
    NSObject* obj = [parameters objectForKey:NAMES_requestType];
    if ([obj isKindOfClass:SDLRequestType.class]) {
        return (SDLRequestType*)obj;
    } else {
        return [SDLRequestType valueOf:(NSString*)obj];
    }
}

- (void)setFileName:(NSString *)fileName {
    [parameters setOrRemoveObject:fileName forKey:NAMES_fileName];
}

-(NSString*) fileName {
    return [parameters objectForKey:NAMES_fileName];
}

@end
