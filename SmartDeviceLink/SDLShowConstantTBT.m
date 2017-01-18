//  SDLShowConstantTBT.m
//


#import "SDLShowConstantTBT.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"

@implementation SDLShowConstantTBT

- (instancetype)init {
    if (self = [super initWithName:SDLNameShowConstantTBT]) {
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
    [parameters sdl_setObject:navigationText1 forName:SDLNameNavigationText1];
}

- (NSString *)navigationText1 {
    return [parameters sdl_objectForName:SDLNameNavigationText1];
}

- (void)setNavigationText2:(NSString *)navigationText2 {
    [parameters sdl_setObject:navigationText2 forName:SDLNameNavigationText2];
}

- (NSString *)navigationText2 {
    return [parameters sdl_objectForName:SDLNameNavigationText2];
}

- (void)setEta:(NSString *)eta {
    [parameters sdl_setObject:eta forName:SDLNameETA];
}

- (NSString *)eta {
    return [parameters sdl_objectForName:SDLNameETA];
}

- (void)setTimeToDestination:(NSString *)timeToDestination {
    [parameters sdl_setObject:timeToDestination forName:SDLNameTimeToDestination];
}

- (NSString *)timeToDestination {
    return [parameters sdl_objectForName:SDLNameTimeToDestination];
}

- (void)setTotalDistance:(NSString *)totalDistance {
    [parameters sdl_setObject:totalDistance forName:SDLNameTotalDistance];
}

- (NSString *)totalDistance {
    return [parameters sdl_objectForName:SDLNameTotalDistance];
}

- (void)setTurnIcon:(SDLImage *)turnIcon {
    [parameters sdl_setObject:turnIcon forName:SDLNameTurnIcon];
}

- (SDLImage *)turnIcon {
    NSObject *obj = [parameters sdl_objectForName:SDLNameTurnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setNextTurnIcon:(SDLImage *)nextTurnIcon {
    [parameters sdl_setObject:nextTurnIcon forName:SDLNameNextTurnIcon];
}

- (SDLImage *)nextTurnIcon {
    NSObject *obj = [parameters sdl_objectForName:SDLNameNextTurnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setDistanceToManeuver:(NSNumber<SDLFloat> *)distanceToManeuver {
    [parameters sdl_setObject:distanceToManeuver forName:SDLNameDistanceToManeuver];
}

- (NSNumber<SDLFloat> *)distanceToManeuver {
    return [parameters sdl_objectForName:SDLNameDistanceToManeuver];
}

- (void)setDistanceToManeuverScale:(NSNumber<SDLFloat> *)distanceToManeuverScale {
    [parameters sdl_setObject:distanceToManeuverScale forName:SDLNameDistanceToManeuverScale];
}

- (NSNumber<SDLFloat> *)distanceToManeuverScale {
    return [parameters sdl_objectForName:SDLNameDistanceToManeuverScale];
}

- (void)setManeuverComplete:(NSNumber<SDLBool> *)maneuverComplete {
    [parameters sdl_setObject:maneuverComplete forName:SDLNameManeuverComplete];
}

- (NSNumber<SDLBool> *)maneuverComplete {
    return [parameters sdl_objectForName:SDLNameManeuverComplete];
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    [parameters sdl_setObject:softButtons forName:SDLNameSoftButtons];
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    NSMutableArray<SDLSoftButton *> *array = [parameters sdl_objectForName:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButton *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
