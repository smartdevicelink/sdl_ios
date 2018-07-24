// SDLStationIDNumber.m
//

#import "SDLStationIDNumber.h"
#import "SDLNames.h"
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
    [store sdl_setObject:countryCode forName:SDLNameCountryCode];
}

- (nullable NSNumber<SDLInt> *)countryCode {
    return [store sdl_objectForName:SDLNameCountryCode];
}


- (void)setFccFacilityId:(nullable NSNumber<SDLInt> *)fccFacilityId {
    [store sdl_setObject:fccFacilityId forName:SDLNameFccFacilityId];
}

- (nullable NSNumber<SDLInt> *)fccFacilityId {
    return [store sdl_objectForName:SDLNameFccFacilityId];
}

@end

NS_ASSUME_NONNULL_END
