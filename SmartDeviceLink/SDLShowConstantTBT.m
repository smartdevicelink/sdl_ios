//  SDLShowConstantTBT.m
//


#import "SDLShowConstantTBT.h"

#import "SDLImage.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"

@implementation SDLShowConstantTBT

- (instancetype)init {
    if (self = [super initWithName:SDLNameShowConstantTBT]) {
    }
    return self;
}

- (void)setNavigationText1:(NSString *)navigationText1 {
    if (navigationText1 != nil) {
        [parameters setObject:navigationText1 forKey:SDLNameNavigationText1];
    } else {
        [parameters removeObjectForKey:SDLNameNavigationText1];
    }
}

- (NSString *)navigationText1 {
    return [parameters objectForKey:SDLNameNavigationText1];
}

- (void)setNavigationText2:(NSString *)navigationText2 {
    if (navigationText2 != nil) {
        [parameters setObject:navigationText2 forKey:SDLNameNavigationText2];
    } else {
        [parameters removeObjectForKey:SDLNameNavigationText2];
    }
}

- (NSString *)navigationText2 {
    return [parameters objectForKey:SDLNameNavigationText2];
}

- (void)setEta:(NSString *)eta {
    if (eta != nil) {
        [parameters setObject:eta forKey:SDLNameETA];
    } else {
        [parameters removeObjectForKey:SDLNameETA];
    }
}

- (NSString *)eta {
    return [parameters objectForKey:SDLNameETA];
}

- (void)setTimeToDestination:(NSString *)timeToDestination {
    if (timeToDestination != nil) {
        [parameters setObject:timeToDestination forKey:SDLNameTimeToDestination];
    } else {
        [parameters removeObjectForKey:SDLNameTimeToDestination];
    }
}

- (NSString *)timeToDestination {
    return [parameters objectForKey:SDLNameTimeToDestination];
}

- (void)setTotalDistance:(NSString *)totalDistance {
    if (totalDistance != nil) {
        [parameters setObject:totalDistance forKey:SDLNameTotalDistance];
    } else {
        [parameters removeObjectForKey:SDLNameTotalDistance];
    }
}

- (NSString *)totalDistance {
    return [parameters objectForKey:SDLNameTotalDistance];
}

- (void)setTurnIcon:(SDLImage *)turnIcon {
    if (turnIcon != nil) {
        [parameters setObject:turnIcon forKey:SDLNameTurnIcon];
    } else {
        [parameters removeObjectForKey:SDLNameTurnIcon];
    }
}

- (SDLImage *)turnIcon {
    NSObject *obj = [parameters objectForKey:SDLNameTurnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setNextTurnIcon:(SDLImage *)nextTurnIcon {
    if (nextTurnIcon != nil) {
        [parameters setObject:nextTurnIcon forKey:SDLNameNextTurnIcon];
    } else {
        [parameters removeObjectForKey:SDLNameNextTurnIcon];
    }
}

- (SDLImage *)nextTurnIcon {
    NSObject *obj = [parameters objectForKey:SDLNameNextTurnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setDistanceToManeuver:(NSNumber *)distanceToManeuver {
    if (distanceToManeuver != nil) {
        [parameters setObject:distanceToManeuver forKey:SDLNameDistanceToManeuver];
    } else {
        [parameters removeObjectForKey:SDLNameDistanceToManeuver];
    }
}

- (NSNumber *)distanceToManeuver {
    return [parameters objectForKey:SDLNameDistanceToManeuver];
}

- (void)setDistanceToManeuverScale:(NSNumber *)distanceToManeuverScale {
    if (distanceToManeuverScale != nil) {
        [parameters setObject:distanceToManeuverScale forKey:SDLNameDistanceToManeuverScale];
    } else {
        [parameters removeObjectForKey:SDLNameDistanceToManeuverScale];
    }
}

- (NSNumber *)distanceToManeuverScale {
    return [parameters objectForKey:SDLNameDistanceToManeuverScale];
}

- (void)setManeuverComplete:(NSNumber *)maneuverComplete {
    if (maneuverComplete != nil) {
        [parameters setObject:maneuverComplete forKey:SDLNameManeuverComplete];
    } else {
        [parameters removeObjectForKey:SDLNameManeuverComplete];
    }
}

- (NSNumber *)maneuverComplete {
    return [parameters objectForKey:SDLNameManeuverComplete];
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (NSMutableArray *)softButtons {
    NSMutableArray *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
