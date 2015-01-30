//  SDLHeadLampStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLHeadLampStatus.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLHeadLampStatus

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setLowBeamsOn:(NSNumber*) lowBeamsOn {
    [store setOrRemoveObject:lowBeamsOn forKey:NAMES_lowBeamsOn];
}

-(NSNumber*) lowBeamsOn {
    return [store objectForKey:NAMES_lowBeamsOn];
}

-(void) setHighBeamsOn:(NSNumber*) highBeamsOn {
    [store setOrRemoveObject:highBeamsOn forKey:NAMES_highBeamsOn];
}

-(NSNumber*) highBeamsOn {
    return [store objectForKey:NAMES_highBeamsOn];
}

-(void) setAmbientLightSensorStatus:(SDLAmbientLightStatus*) ambientLightSensorStatus {
    [store setOrRemoveObject:ambientLightSensorStatus forKey:NAMES_ambientLightSensorStatus];
}

-(SDLAmbientLightStatus*) ambientLightSensorStatus {
    NSObject* obj = [store objectForKey:NAMES_ambientLightSensorStatus];
    if ([obj isKindOfClass:SDLAmbientLightStatus.class]) {
        return (SDLAmbientLightStatus*)obj;
    } else {
        return [SDLAmbientLightStatus valueOf:(NSString*)obj];
    }
}

@end
