//  SDLShowConstantTBT.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLShowConstantTBT.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLSoftButton.h>

@implementation SDLShowConstantTBT

-(id) init {
    if (self = [super initWithName:NAMES_ShowConstantTBT]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setNavigationText1:(NSString *)navigationText1 {
    [parameters setOrRemoveObject:navigationText1 forKey:NAMES_navigationText1];
}

-(NSString*) navigationText1 {
    return [parameters objectForKey:NAMES_navigationText1];
}

- (void)setNavigationText2:(NSString *)navigationText2 {
    [parameters setOrRemoveObject:navigationText2 forKey:NAMES_navigationText2];
}

-(NSString*) navigationText2 {
    return [parameters objectForKey:NAMES_navigationText2];
}

- (void)setEta:(NSString *)eta {
    [parameters setOrRemoveObject:eta forKey:NAMES_eta];
}

-(NSString*) eta {
    return [parameters objectForKey:NAMES_eta];
}

- (void)setTimeToDestination:(NSString *)timeToDestination {
    [parameters setOrRemoveObject:timeToDestination forKey:NAMES_timeToDestination];
}

-(NSString*) timeToDestination {
    return [parameters objectForKey:NAMES_timeToDestination];
}

- (void)setTotalDistance:(NSString *)totalDistance {
    [parameters setOrRemoveObject:totalDistance forKey:NAMES_totalDistance];
}

-(NSString*) totalDistance {
    return [parameters objectForKey:NAMES_totalDistance];
}

- (void)setTurnIcon:(SDLImage *)turnIcon {
    [parameters setOrRemoveObject:turnIcon forKey:NAMES_turnIcon];
}

-(SDLImage*) turnIcon {
    NSObject* obj = [parameters objectForKey:NAMES_turnIcon];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setNextTurnIcon:(SDLImage *)nextTurnIcon {
    [parameters setOrRemoveObject:nextTurnIcon forKey:NAMES_nextTurnIcon];
}

-(SDLImage*) nextTurnIcon {
    NSObject* obj = [parameters objectForKey:NAMES_nextTurnIcon];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setDistanceToManeuver:(NSNumber *)distanceToManeuver {
    [parameters setOrRemoveObject:distanceToManeuver forKey:NAMES_distanceToManeuver];
}

-(NSNumber*) distanceToManeuver {
    return [parameters objectForKey:NAMES_distanceToManeuver];
}

- (void)setDistanceToManeuverScale:(NSNumber *)distanceToManeuverScale {
    [parameters setOrRemoveObject:distanceToManeuverScale forKey:NAMES_distanceToManeuverScale];
}

-(NSNumber*) distanceToManeuverScale {
    return [parameters objectForKey:NAMES_distanceToManeuverScale];
}

- (void)setManeuverComplete:(NSNumber *)maneuverComplete {
    [parameters setOrRemoveObject:maneuverComplete forKey:NAMES_maneuverComplete];
}

-(NSNumber*) maneuverComplete {
    return [parameters objectForKey:NAMES_maneuverComplete];
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    [parameters setOrRemoveObject:softButtons forKey:NAMES_softButtons];
}

-(NSMutableArray*) softButtons {
    NSMutableArray* array = [parameters objectForKey:NAMES_softButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

@end
