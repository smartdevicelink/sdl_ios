//  SDLOnSystemRequest.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnSystemRequest.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnSystemRequest

-(id) init {
    if (self = [super initWithName:NAMES_OnSystemRequest]) {}
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

- (void)setUrl:(NSString *)url {
    [parameters setOrRemoveObject:url forKey:NAMES_url];
}

-(NSString*) url {
    return [parameters objectForKey:NAMES_url];
}

- (void)setTimeout:(NSNumber *)timeout {
    [parameters setOrRemoveObject:timeout forKey:NAMES_timeout];
}

-(NSNumber*) timeout {
    return [parameters objectForKey:NAMES_timeout];
}

- (void)setFileType:(SDLFileType *)fileType {
    [parameters setOrRemoveObject:fileType forKey:NAMES_fileType];
}

-(SDLFileType*) fileType {
    NSObject* obj = [parameters objectForKey:NAMES_fileType];
    if ([obj isKindOfClass:SDLFileType.class]) {
        return (SDLFileType*)obj;
    } else {
        return [SDLFileType valueOf:(NSString*)obj];
    }
}

- (void)setOffset:(NSNumber *)offset {
    [parameters setOrRemoveObject:offset forKey:NAMES_offset];
}

-(NSNumber*) offset {
    return [parameters objectForKey:NAMES_offset];
}

- (void)setLength:(NSNumber *)length {
    [parameters setOrRemoveObject:length forKey:NAMES_length];
}

-(NSNumber*) length {
    return [parameters objectForKey:NAMES_length];
}

@end
