//  SDLSingleTireStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSingleTireStatus.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSingleTireStatus

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setStatus:(SDLComponentVolumeStatus*) status {
    [store setOrRemoveObject:status forKey:NAMES_status];
}

-(SDLComponentVolumeStatus*) status {
    NSObject* obj = [store objectForKey:NAMES_status];
    if ([obj isKindOfClass:SDLComponentVolumeStatus.class]) {
        return (SDLComponentVolumeStatus*)obj;
    } else {
        return [SDLComponentVolumeStatus valueOf:(NSString*)obj];
    }
}

@end
