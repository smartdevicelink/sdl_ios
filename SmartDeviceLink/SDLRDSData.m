//
//  SDLRDSData.m
//

#import "SDLRDSData.h"
#include "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRDSData

- (instancetype)initWithProgramService:(nullable NSString *)programService radioText:(nullable NSString *)radioText clockText:(nullable NSString *)clockText programIdentification:(nullable NSString *)programIdentification programType:(nullable NSNumber<SDLInt> *)programType trafficProgramIdentification:(nullable NSNumber<SDLBool> *)trafficProgramIdentification trafficAnnouncementIdentification:(nullable NSNumber<SDLBool> *)trafficAnnouncementIdentification region:(nullable NSString *)region {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.programService = programService;
    self.radioText = radioText;
    self.clockText = clockText;
    self.programIdentification = programIdentification;
    self.programType = programType;
    self.trafficProgramIdentification = trafficProgramIdentification;
    self.trafficAnnouncementIdentification = trafficAnnouncementIdentification;
    self.region = region;
    return self;
}

- (void)setProgramService:(nullable NSString *)programService {
    [store sdl_setObject:programService forName:SDLNameProgramService];
}

- (nullable NSString *)programService {
    return [store sdl_objectForName:SDLNameProgramService];
}

- (void)setRadioText:(nullable NSString *)radioText {
    [store sdl_setObject:radioText forName:SDLNameRadioText];
}

- (nullable NSString *)radioText {
    return [store sdl_objectForName:SDLNameRadioText];
}

- (void)setClockText:(nullable NSString *)clockText {
    [store sdl_setObject:clockText forName:SDLNameClockText];
}

- (nullable NSString *)clockText {
    return [store sdl_objectForName:SDLNameClockText];
}

- (void)setProgramIdentification:(nullable NSString *)programIdentification {
    [store sdl_setObject:programIdentification forName:SDLNameProgramIdentification];
}

- (nullable NSString *)programIdentification {
    return [store sdl_objectForName:SDLNameProgramIdentification];
}

- (void)setProgramType:(nullable NSNumber<SDLInt> *)programType {
    [store sdl_setObject:programType forName:SDLNameProgramType];
}

- (nullable NSNumber<SDLInt> *)programType {
    return [store sdl_objectForName:SDLNameProgramType];
}

- (void)setTrafficProgramIdentification:(nullable NSNumber<SDLBool> *)trafficProgramIdentification {
    [store sdl_setObject:trafficProgramIdentification forName:SDLNameTrafficProgramIdentification];
}

- (nullable NSNumber<SDLBool> *)trafficProgramIdentification {
    return [store sdl_objectForName:SDLNameTrafficProgramIdentification];
}

- (void)setTrafficAnnouncementIdentification:(nullable NSNumber<SDLBool> *)trafficAnnouncementIdentification {
    [store sdl_setObject:trafficAnnouncementIdentification forName:SDLNameTrafficAnnouncementIdentification];
}

- (nullable NSNumber<SDLBool> *)trafficAnnouncementIdentification {
    return [store sdl_objectForName:SDLNameTrafficAnnouncementIdentification];
}

- (void)setRegion:(nullable NSString *)region {
    [store sdl_setObject:region forName:SDLNameRegion];
}

- (nullable NSString *)region {
    return [store sdl_objectForName:SDLNameRegion];
}

@end

NS_ASSUME_NONNULL_END
