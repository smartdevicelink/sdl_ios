//  SDLSISData.m
//

#import "SDLSISData.h"

#import "SDLStationIDNumber.h"
#import "SDLGPSData.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLSISData

- (instancetype)initWithStationShortName:(nullable NSString *)stationShortName stationIDNumber:(nullable SDLStationIDNumber *)stationIDNumber stationLongName:(nullable NSString *)stationLongName stationLocation:(nullable SDLGPSData *)stationLocation stationMessage:(nullable NSString *)stationMessage {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.stationShortName = stationShortName;
    self.stationIDNumber = stationIDNumber;
    self.stationLongName = stationLongName;
    self.stationLocation = stationLocation;
    self.stationMessage = stationMessage;

    return self;
}

- (void)setStationShortName:(nullable NSString *)stationShortName {
    [store sdl_setObject:stationShortName forName:SDLNameStationShortName];
}

- (nullable NSString *)stationShortName {
    return [store sdl_objectForName:SDLNameStationShortName];
}

- (void)setStationIDNumber:(nullable SDLStationIDNumber *)stationIDNumber {
    [store sdl_setObject:stationIDNumber forName:SDLNameStationIDNumber];
}

- (nullable SDLStationIDNumber *)stationIDNumber {
    return [store sdl_objectForName:SDLNameStationIDNumber ofClass:SDLStationIDNumber.class];
}

- (void)setStationLongName:(nullable NSString *)stationLongName {
    [store sdl_setObject:stationLongName forName:SDLNameStationLongName];
}

- (nullable NSString *)stationLongName {
    return [store sdl_objectForName:SDLNameStationLongName];
}

- (void)setStationLocation:(nullable SDLGPSData *)stationLocation {
    [store sdl_setObject:stationLocation forName:SDLNameStationLocation];
}

- (nullable SDLGPSData *)stationLocation {
    return [store sdl_objectForName:SDLNameStationLocation ofClass:SDLGPSData.class];
}

- (void)setStationMessage:(nullable NSString *)stationMessage {
    [store sdl_setObject:stationMessage forName:SDLNameStationMessage];
}

- (nullable NSString *)stationMessage {
    return [store sdl_objectForName:SDLNameStationMessage];
}

@end

NS_ASSUME_NONNULL_END
