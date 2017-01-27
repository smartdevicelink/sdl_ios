//  SDLShowConstantTBT.m
//


#import "SDLShowConstantTBT.h"

#import "NSMutableDictionary+Store.h"
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

- (instancetype)initWithNavigationText1:(nullable NSString *)navigationText1 navigationText2:(nullable NSString *)navigationText2 eta:(nullable NSString *)eta timeToDestination:(nullable NSString *)timeToDestination totalDistance:(nullable NSString *)totalDistance turnIcon:(nullable SDLImage *)turnIcon nextTurnIcon:(nullable SDLImage *)nextTurnIcon distanceToManeuver:(double)distanceToManeuver distanceToManeuverScale:(double)distanceToManeuverScale maneuverComplete:(BOOL)maneuverComplete softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
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
    [parameters sdl_setObject:navigationText1 forName:SDLNameNavigationText1];
}

- (nullable NSString *)navigationText1 {
    return [parameters sdl_objectForName:SDLNameNavigationText1];
}

- (void)setNavigationText2:(nullable NSString *)navigationText2 {
    [parameters sdl_setObject:navigationText2 forName:SDLNameNavigationText2];
}

- (nullable NSString *)navigationText2 {
    return [parameters sdl_objectForName:SDLNameNavigationText2];
}

- (void)setEta:(nullable NSString *)eta {
    [parameters sdl_setObject:eta forName:SDLNameETA];
}

- (nullable NSString *)eta {
    return [parameters sdl_objectForName:SDLNameETA];
}

- (void)setTimeToDestination:(nullable NSString *)timeToDestination {
    [parameters sdl_setObject:timeToDestination forName:SDLNameTimeToDestination];
}

- (nullable NSString *)timeToDestination {
    return [parameters sdl_objectForName:SDLNameTimeToDestination];
}

- (void)setTotalDistance:(nullable NSString *)totalDistance {
    [parameters sdl_setObject:totalDistance forName:SDLNameTotalDistance];
}

- (nullable NSString *)totalDistance {
    return [parameters sdl_objectForName:SDLNameTotalDistance];
}

- (void)setTurnIcon:(nullable SDLImage *)turnIcon {
    [parameters sdl_setObject:turnIcon forName:SDLNameTurnIcon];
}

- (nullable SDLImage *)turnIcon {
    return [parameters sdl_objectForName:SDLNameTurnIcon ofClass:SDLImage.class];
}

- (void)setNextTurnIcon:(nullable SDLImage *)nextTurnIcon {
    [parameters sdl_setObject:nextTurnIcon forName:SDLNameNextTurnIcon];
}

- (nullable SDLImage *)nextTurnIcon {
    return [parameters sdl_objectForName:SDLNameNextTurnIcon ofClass:SDLImage.class];
}

- (void)setDistanceToManeuver:(nullable NSNumber<SDLFloat> *)distanceToManeuver {
    [parameters sdl_setObject:distanceToManeuver forName:SDLNameDistanceToManeuver];
}

- (nullable NSNumber<SDLFloat> *)distanceToManeuver {
    return [parameters sdl_objectForName:SDLNameDistanceToManeuver];
}

- (void)setDistanceToManeuverScale:(nullable NSNumber<SDLFloat> *)distanceToManeuverScale {
    [parameters sdl_setObject:distanceToManeuverScale forName:SDLNameDistanceToManeuverScale];
}

- (nullable NSNumber<SDLFloat> *)distanceToManeuverScale {
    return [parameters sdl_objectForName:SDLNameDistanceToManeuverScale];
}

- (void)setManeuverComplete:(nullable NSNumber<SDLBool> *)maneuverComplete {
    [parameters sdl_setObject:maneuverComplete forName:SDLNameManeuverComplete];
}

- (nullable NSNumber<SDLBool> *)maneuverComplete {
    return [parameters sdl_objectForName:SDLNameManeuverComplete];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [parameters sdl_setObject:softButtons forName:SDLNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [parameters sdl_objectsForName:SDLNameSoftButtons ofClass:SDLSoftButton.class];
}

@end

NS_ASSUME_NONNULL_END
