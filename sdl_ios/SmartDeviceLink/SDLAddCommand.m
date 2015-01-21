//  SDLAddCommand.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLAddCommand.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLAddCommand

-(id) init {
    if (self = [super initWithName:NAMES_AddCommand]) {}
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

- (void)setMenuParams:(SDLMenuParams *)menuParams {
    [parameters setOrRemoveObject:menuParams forKey:NAMES_menuParams];
}

-(SDLMenuParams*) menuParams {
    NSObject* obj = [parameters objectForKey:NAMES_menuParams];
    if ([obj isKindOfClass:SDLMenuParams.class]) {
        return (SDLMenuParams*)obj;
    } else {
        return [[SDLMenuParams alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setVrCommands:(NSMutableArray *)vrCommands {
    [parameters setOrRemoveObject:vrCommands forKey:NAMES_vrCommands];
}

-(NSMutableArray*) vrCommands {
    return [parameters objectForKey:NAMES_vrCommands];
}

- (void)setCmdIcon:(SDLImage *)cmdIcon {
    [parameters setOrRemoveObject:cmdIcon forKey:NAMES_cmdIcon];
}

-(SDLImage*) cmdIcon {
    NSObject* obj = [parameters objectForKey:NAMES_cmdIcon];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
