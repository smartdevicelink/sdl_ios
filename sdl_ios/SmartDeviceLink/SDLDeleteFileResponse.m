//  SDLDeleteFileResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDeleteFileResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDeleteFileResponse

-(id) init {
    if (self = [super initWithName:NAMES_DeleteFile]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setSpaceAvailable:(NSNumber *)spaceAvailable {
    [parameters setOrRemoveObject:spaceAvailable forKey:NAMES_spaceAvailable];
}

-(NSNumber*) spaceAvailable {
    return [parameters objectForKey:NAMES_spaceAvailable];
}

@end
