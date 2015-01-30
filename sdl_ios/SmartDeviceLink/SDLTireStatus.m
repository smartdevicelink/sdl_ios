//  SDLTireStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLTireStatus.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLTireStatus

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setPressureTelltale:(SDLWarningLightStatus*) pressureTelltale {
    [store setOrRemoveObject:pressureTelltale forKey:NAMES_pressureTelltale];
}

-(SDLWarningLightStatus*) pressureTelltale {
    NSObject* obj = [store objectForKey:NAMES_pressureTelltale];
    if ([obj isKindOfClass:SDLWarningLightStatus.class]) {
        return (SDLWarningLightStatus*)obj;
    } else {
        return [SDLWarningLightStatus valueOf:(NSString*)obj];
    }
}

-(void) setLeftFront:(SDLSingleTireStatus*) leftFront {
    [store setOrRemoveObject:leftFront forKey:NAMES_leftFront];
}

-(SDLSingleTireStatus*) leftFront {
    NSObject* obj = [store objectForKey:NAMES_leftFront];
    if ([obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus*)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setRightFront:(SDLSingleTireStatus*) rightFront {
    [store setOrRemoveObject:rightFront forKey:NAMES_rightFront];
}

-(SDLSingleTireStatus*) rightFront {
    NSObject* obj = [store objectForKey:NAMES_rightFront];
    if ([obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus*)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setLeftRear:(SDLSingleTireStatus*) leftRear {
    [store setOrRemoveObject:leftRear forKey:NAMES_leftRear];
}

-(SDLSingleTireStatus*) leftRear {
    NSObject* obj = [store objectForKey:NAMES_leftRear];
    if ([obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus*)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setRightRear:(SDLSingleTireStatus*) rightRear {
    [store setOrRemoveObject:rightRear forKey:NAMES_rightRear];
}

-(SDLSingleTireStatus*) rightRear {
    NSObject* obj = [store objectForKey:NAMES_rightRear];
    if ([obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus*)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setInnerLeftRear:(SDLSingleTireStatus*) innerLeftRear {
    [store setOrRemoveObject:innerLeftRear forKey:NAMES_innerLeftRear];
}

-(SDLSingleTireStatus*) innerLeftRear {
    NSObject* obj = [store objectForKey:NAMES_innerLeftRear];
    if ([obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus*)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setInnerRightRear:(SDLSingleTireStatus*) innerRightRear {
    [store setOrRemoveObject:innerRightRear forKey:NAMES_innerRightRear];
}

-(SDLSingleTireStatus*) innerRightRear {
    NSObject* obj = [store objectForKey:NAMES_innerRightRear];
    if ([obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus*)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
