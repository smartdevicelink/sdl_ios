//  SDLDeleteCommand.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDeleteCommand.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDeleteCommand

-(id) init {
    if (self = [super initWithName:NAMES_DeleteCommand]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setCmdID:(NSNumber *)cmdID {
    [parameters setOrRemoveObject:cmdID forKey:NAMES_cmdID];
}

-(NSNumber*) cmdID {
    return [parameters objectForKey:NAMES_cmdID];
}

@end
