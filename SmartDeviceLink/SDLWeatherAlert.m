//
//  SDLWeatherAlert.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLWeatherAlert.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLWeatherAlert

- (instancetype)initWithTitle:(nullable NSString *)title summary:(nullable NSString *)summary expires:(nullable SDLDateTime *)expires regions:(nullable NSArray<NSString *> *)regions severity:(nullable NSString *)severity timeIssued:(nullable SDLDateTime *)timeIssued {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.title = title;
    self.summary = summary;
    self.expires = expires;
    self.regions = regions;
    self.severity = severity;
    self.timeIssued = timeIssued;

    return self;
}

- (void)setTitle:(nullable NSString *)title {
    [store sdl_setObject:title forName:SDLNameTitle];
}

- (nullable NSString *)title {
    return [store sdl_objectForName:SDLNameTitle];
}

- (void)setSummary:(nullable NSString *)summary {
    [store sdl_setObject:summary forName:SDLNameSummary];
}

- (nullable NSString *)summary {
    return [store sdl_objectForName:SDLNameSummary];
}

- (void)setExpires:(nullable SDLDateTime *)expires {
    [store sdl_setObject:expires forName:SDLNameExpires];
}

- (nullable SDLDateTime *)expires {
    return [store sdl_objectForName:SDLNameExpires ofClass:SDLDateTime.class];
}

- (void)setRegions:(nullable NSArray<NSString *> *)regions {
    [store sdl_setObject:regions forName:SDLNameRegions];
}

- (nullable NSArray<NSString *> *)regions {
    return [store sdl_objectForName:SDLNameRegions];
}

- (void)setSeverity:(nullable NSString *)severity {
    [store sdl_setObject:severity forName:SDLNameSeverity];
}

- (nullable NSString *)severity {
    return [store sdl_objectForName:SDLNameSeverity];
}

- (void)setTimeIssued:(nullable SDLDateTime *)timeIssued {
    [store sdl_setObject:timeIssued forName:SDLNameTimeIssued];
}

- (nullable SDLDateTime *)timeIssued {
    return [store sdl_objectForName:SDLNameTimeIssued ofClass:SDLDateTime.class];
}

@end

NS_ASSUME_NONNULL_END
