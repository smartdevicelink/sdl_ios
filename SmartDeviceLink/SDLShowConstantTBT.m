//  SDLShowConstantTBT.m
//


#import "SDLShowConstantTBT.h"

#import "SDLImage.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLShowConstantTBT

- (instancetype)init {
    if (self = [super initWithName:SDLNameShowConstantTBT]) {
    }
    return self;
}

- (instancetype)initWithNavigationText1:(nullable NSString *)navigationText1 navigationText2:(nullable NSString *)navigationText2 eta:(nullable NSString *)eta timeToDestination:(nullable NSString *)timeToDestination totalDistance:(nullable NSString *)totalDistance turnIcon:(nullable SDLImage *)turnIcon nextTurnIcon:(nullable SDLImage *)nextTurnIcon distanceToManeuver:(CGFloat)distanceToManeuver distanceToManeuverScale:(CGFloat)distanceToManeuverScale maneuverComplete:(BOOL)maneuverComplete softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
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

- (void)setNavigationText1:(nullable NSString *)navigationText1 {
    if (navigationText1 != nil) {
        [parameters setObject:navigationText1 forKey:SDLNameNavigationText1];
    } else {
        [parameters removeObjectForKey:SDLNameNavigationText1];
    }
}

- (nullable NSString *)navigationText1 {
    return [parameters objectForKey:SDLNameNavigationText1];
}

- (void)setNavigationText2:(nullable NSString *)navigationText2 {
    if (navigationText2 != nil) {
        [parameters setObject:navigationText2 forKey:SDLNameNavigationText2];
    } else {
        [parameters removeObjectForKey:SDLNameNavigationText2];
    }
}

- (nullable NSString *)navigationText2 {
    return [parameters objectForKey:SDLNameNavigationText2];
}

- (void)setEta:(nullable NSString *)eta {
    if (eta != nil) {
        [parameters setObject:eta forKey:SDLNameETA];
    } else {
        [parameters removeObjectForKey:SDLNameETA];
    }
}

- (nullable NSString *)eta {
    return [parameters objectForKey:SDLNameETA];
}

- (void)setTimeToDestination:(nullable NSString *)timeToDestination {
    if (timeToDestination != nil) {
        [parameters setObject:timeToDestination forKey:SDLNameTimeToDestination];
    } else {
        [parameters removeObjectForKey:SDLNameTimeToDestination];
    }
}

- (nullable NSString *)timeToDestination {
    return [parameters objectForKey:SDLNameTimeToDestination];
}

- (void)setTotalDistance:(nullable NSString *)totalDistance {
    if (totalDistance != nil) {
        [parameters setObject:totalDistance forKey:SDLNameTotalDistance];
    } else {
        [parameters removeObjectForKey:SDLNameTotalDistance];
    }
}

- (nullable NSString *)totalDistance {
    return [parameters objectForKey:SDLNameTotalDistance];
}

- (void)setTurnIcon:(nullable SDLImage *)turnIcon {
    if (turnIcon != nil) {
        [parameters setObject:turnIcon forKey:SDLNameTurnIcon];
    } else {
        [parameters removeObjectForKey:SDLNameTurnIcon];
    }
}

- (nullable SDLImage *)turnIcon {
    NSObject *obj = [parameters objectForKey:SDLNameTurnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setNextTurnIcon:(nullable SDLImage *)nextTurnIcon {
    if (nextTurnIcon != nil) {
        [parameters setObject:nextTurnIcon forKey:SDLNameNextTurnIcon];
    } else {
        [parameters removeObjectForKey:SDLNameNextTurnIcon];
    }
}

- (nullable SDLImage *)nextTurnIcon {
    NSObject *obj = [parameters objectForKey:SDLNameNextTurnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setDistanceToManeuver:(nullable NSNumber<SDLFloat> *)distanceToManeuver {
    if (distanceToManeuver != nil) {
        [parameters setObject:distanceToManeuver forKey:SDLNameDistanceToManeuver];
    } else {
        [parameters removeObjectForKey:SDLNameDistanceToManeuver];
    }
}

- (nullable NSNumber<SDLFloat> *)distanceToManeuver {
    return [parameters objectForKey:SDLNameDistanceToManeuver];
}

- (void)setDistanceToManeuverScale:(nullable NSNumber<SDLFloat> *)distanceToManeuverScale {
    if (distanceToManeuverScale != nil) {
        [parameters setObject:distanceToManeuverScale forKey:SDLNameDistanceToManeuverScale];
    } else {
        [parameters removeObjectForKey:SDLNameDistanceToManeuverScale];
    }
}

- (nullable NSNumber<SDLFloat> *)distanceToManeuverScale {
    return [parameters objectForKey:SDLNameDistanceToManeuverScale];
}

- (void)setManeuverComplete:(nullable NSNumber<SDLBool> *)maneuverComplete {
    if (maneuverComplete != nil) {
        [parameters setObject:maneuverComplete forKey:SDLNameManeuverComplete];
    } else {
        [parameters removeObjectForKey:SDLNameManeuverComplete];
    }
}

- (nullable NSNumber<SDLBool> *)maneuverComplete {
    return [parameters objectForKey:SDLNameManeuverComplete];
}

- (void)setSoftButtons:(nullable NSMutableArray<SDLSoftButton *> *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (nullable NSMutableArray<SDLSoftButton *> *)softButtons {
    NSMutableArray<SDLSoftButton *> *array = [parameters objectForKey:SDLNameSoftButtons];
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

NS_ASSUME_NONNULL_END
