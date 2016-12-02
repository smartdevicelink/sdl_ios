//  SDLShowConstantTBT.m
//


#import "SDLShowConstantTBT.h"

#import "SDLImage.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"


@implementation SDLShowConstantTBT

- (instancetype)init {
    if (self = [super initWithName:NAMES_ShowConstantTBT]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithNavigationText1:(NSString *)navigationText1 navigationText2:(NSString *)navigationText2 eta:(NSString *)eta timeToDestination:(NSString *)timeToDestination totalDistance:(NSString *)totalDistance turnIcon:(SDLImage *)turnIcon nextTurnIcon:(SDLImage *)nextTurnIcon distanceToManeuver:(double)distanceToManeuver distanceToManeuverScale:(double)distanceToManeuverScale maneuverComplete:(BOOL)maneuverComplete softButtons:(NSArray<SDLSoftButton *> *)softButtons {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.navigationText1 = navigationText1;
    self.navigationText2 = navigationText2;
    self.eta = eta;
    self.timeToDestination = timeToDestination;
    self.totalDistance = totalDistance;
    self.turnIcon = turnIcon;
    self.nextTurnIcon = nextTurnIcon;
    self.distanceToManeuver = @(distanceToManeuver);
    self.distanceToManeuverScale = @(distanceToManeuverScale);
    self.maneuverComplete = @(maneuverComplete);
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (void)setNavigationText1:(NSString *)navigationText1 {
    if (navigationText1 != nil) {
        [parameters setObject:navigationText1 forKey:NAMES_navigationText1];
    } else {
        [parameters removeObjectForKey:NAMES_navigationText1];
    }
}

- (NSString *)navigationText1 {
    return [parameters objectForKey:NAMES_navigationText1];
}

- (void)setNavigationText2:(NSString *)navigationText2 {
    if (navigationText2 != nil) {
        [parameters setObject:navigationText2 forKey:NAMES_navigationText2];
    } else {
        [parameters removeObjectForKey:NAMES_navigationText2];
    }
}

- (NSString *)navigationText2 {
    return [parameters objectForKey:NAMES_navigationText2];
}

- (void)setEta:(NSString *)eta {
    if (eta != nil) {
        [parameters setObject:eta forKey:NAMES_eta];
    } else {
        [parameters removeObjectForKey:NAMES_eta];
    }
}

- (NSString *)eta {
    return [parameters objectForKey:NAMES_eta];
}

- (void)setTimeToDestination:(NSString *)timeToDestination {
    if (timeToDestination != nil) {
        [parameters setObject:timeToDestination forKey:NAMES_timeToDestination];
    } else {
        [parameters removeObjectForKey:NAMES_timeToDestination];
    }
}

- (NSString *)timeToDestination {
    return [parameters objectForKey:NAMES_timeToDestination];
}

- (void)setTotalDistance:(NSString *)totalDistance {
    if (totalDistance != nil) {
        [parameters setObject:totalDistance forKey:NAMES_totalDistance];
    } else {
        [parameters removeObjectForKey:NAMES_totalDistance];
    }
}

- (NSString *)totalDistance {
    return [parameters objectForKey:NAMES_totalDistance];
}

- (void)setTurnIcon:(SDLImage *)turnIcon {
    if (turnIcon != nil) {
        [parameters setObject:turnIcon forKey:NAMES_turnIcon];
    } else {
        [parameters removeObjectForKey:NAMES_turnIcon];
    }
}

- (SDLImage *)turnIcon {
    NSObject *obj = [parameters objectForKey:NAMES_turnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setNextTurnIcon:(SDLImage *)nextTurnIcon {
    if (nextTurnIcon != nil) {
        [parameters setObject:nextTurnIcon forKey:NAMES_nextTurnIcon];
    } else {
        [parameters removeObjectForKey:NAMES_nextTurnIcon];
    }
}

- (SDLImage *)nextTurnIcon {
    NSObject *obj = [parameters objectForKey:NAMES_nextTurnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setDistanceToManeuver:(NSNumber *)distanceToManeuver {
    if (distanceToManeuver != nil) {
        [parameters setObject:distanceToManeuver forKey:NAMES_distanceToManeuver];
    } else {
        [parameters removeObjectForKey:NAMES_distanceToManeuver];
    }
}

- (NSNumber *)distanceToManeuver {
    return [parameters objectForKey:NAMES_distanceToManeuver];
}

- (void)setDistanceToManeuverScale:(NSNumber *)distanceToManeuverScale {
    if (distanceToManeuverScale != nil) {
        [parameters setObject:distanceToManeuverScale forKey:NAMES_distanceToManeuverScale];
    } else {
        [parameters removeObjectForKey:NAMES_distanceToManeuverScale];
    }
}

- (NSNumber *)distanceToManeuverScale {
    return [parameters objectForKey:NAMES_distanceToManeuverScale];
}

- (void)setManeuverComplete:(NSNumber *)maneuverComplete {
    if (maneuverComplete != nil) {
        [parameters setObject:maneuverComplete forKey:NAMES_maneuverComplete];
    } else {
        [parameters removeObjectForKey:NAMES_maneuverComplete];
    }
}

- (NSNumber *)maneuverComplete {
    return [parameters objectForKey:NAMES_maneuverComplete];
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:NAMES_softButtons];
    } else {
        [parameters removeObjectForKey:NAMES_softButtons];
    }
}

- (NSMutableArray *)softButtons {
    NSMutableArray *array = [parameters objectForKey:NAMES_softButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

@end
