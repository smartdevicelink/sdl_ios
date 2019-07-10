// SDLStationIDNumber.m
//

#import "SDLStationIDNumber.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLStationIDNumber

- (instancetype)initWithCountryCode:(nullable NSNumber<SDLInt> *)countryCode fccFacilityId:(nullable NSNumber<SDLInt> *)id {
    self = [self init];
    if(!self) {
        return nil;
    }

    self.countryCode = countryCode;
    self.fccFacilityId = id;
    
    return self;
}

- (void)setCountryCode:(nullable NSNumber<SDLInt> *)countryCode {
    [self.store sdl_setObject:countryCode forName:SDLRPCParameterNameCountryCode];
}

- (nullable NSNumber<SDLInt> *)countryCode {
    return [self.store sdl_objectForName:SDLRPCParameterNameCountryCode ofClass:NSNumber.class error:nil];
}


- (void)setFccFacilityId:(nullable NSNumber<SDLInt> *)fccFacilityId {
    [self.store sdl_setObject:fccFacilityId forName:SDLRPCParameterNameFCCFacilityId];
}

- (nullable NSNumber<SDLInt> *)fccFacilityId {
    return [self.store sdl_objectForName:SDLRPCParameterNameFCCFacilityId ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
