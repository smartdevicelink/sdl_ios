//
//  SDLRDSData.m
//

#import "SDLRDSData.h"
#include "SDLRPCParameterNames.h"
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
    [self.store sdl_setObject:programService forName:SDLRPCParameterNameProgramService];
}

- (nullable NSString *)programService {
    return [self.store sdl_objectForName:SDLRPCParameterNameProgramService ofClass:NSString.class error:nil];
}

- (void)setRadioText:(nullable NSString *)radioText {
    [self.store sdl_setObject:radioText forName:SDLRPCParameterNameRadioText];
}

- (nullable NSString *)radioText {
    return [self.store sdl_objectForName:SDLRPCParameterNameRadioText ofClass:NSString.class error:nil];
}

- (void)setClockText:(nullable NSString *)clockText {
    [self.store sdl_setObject:clockText forName:SDLRPCParameterNameClockText];
}

- (nullable NSString *)clockText {
    return [self.store sdl_objectForName:SDLRPCParameterNameClockText ofClass:NSString.class error:nil];
}

- (void)setProgramIdentification:(nullable NSString *)programIdentification {
    [self.store sdl_setObject:programIdentification forName:SDLRPCParameterNameProgramIdentification];
}

- (nullable NSString *)programIdentification {
    return [self.store sdl_objectForName:SDLRPCParameterNameProgramIdentification ofClass:NSString.class error:nil];
}

- (void)setProgramType:(nullable NSNumber<SDLInt> *)programType {
    [self.store sdl_setObject:programType forName:SDLRPCParameterNameProgramType];
}

- (nullable NSNumber<SDLInt> *)programType {
    return [self.store sdl_objectForName:SDLRPCParameterNameProgramType ofClass:NSNumber.class error:nil];
}

- (void)setTrafficProgramIdentification:(nullable NSNumber<SDLBool> *)trafficProgramIdentification {
    [self.store sdl_setObject:trafficProgramIdentification forName:SDLRPCParameterNameTrafficProgramIdentification];
}

- (nullable NSNumber<SDLBool> *)trafficProgramIdentification {
    return [self.store sdl_objectForName:SDLRPCParameterNameTrafficProgramIdentification ofClass:NSNumber.class error:nil];
}

- (void)setTrafficAnnouncementIdentification:(nullable NSNumber<SDLBool> *)trafficAnnouncementIdentification {
    [self.store sdl_setObject:trafficAnnouncementIdentification forName:SDLRPCParameterNameTrafficAnnouncementIdentification];
}

- (nullable NSNumber<SDLBool> *)trafficAnnouncementIdentification {
    return [self.store sdl_objectForName:SDLRPCParameterNameTrafficAnnouncementIdentification ofClass:NSNumber.class error:nil];
}

- (void)setRegion:(nullable NSString *)region {
    [self.store sdl_setObject:region forName:SDLRPCParameterNameRegion];
}

- (nullable NSString *)region {
    return [self.store sdl_objectForName:SDLRPCParameterNameRegion ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
