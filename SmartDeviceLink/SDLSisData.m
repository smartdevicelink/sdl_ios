//  SDLSisData.m
//

#import "SDLSisData.h"

#import "SDLStationIDNumber.h"
#import "SDLGPSLocation.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLSisData

- (instancetype)initWithStationShortName:(nullable NSString *)shortName stationID:(nullable SDLStationIDNumber *)id stationLongName:(nullable NSString *)longName stationLocation:(nullable SDLGPSLocation *)location stationMessage:(nullable NSString *)message {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.stationShortName = shortName;
    self.stationIDNumber = id;
    self.stationLongName = longName;
    self.stationLocation = location;
    self.stationMessage = message;

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

- (void)setStationLocation:(nullable SDLGPSLocation *)stationLocation {
    [store sdl_setObject:stationLocation forName:SDLNameStationLocation];
}

- (nullable SDLGPSLocation *)stationLocation {
    return [store sdl_objectForName:SDLNameStationLocation ofClass:SDLGPSLocation.class];
}

- (void)setStationMessage:(nullable NSString *)stationMessage {
    [store sdl_setObject:stationMessage forName:SDLNameStationMessage];
}

- (nullable NSString *)stationMessage {
    return [store sdl_objectForName:SDLNameStationMessage];
}

@end

NS_ASSUME_NONNULL_END
