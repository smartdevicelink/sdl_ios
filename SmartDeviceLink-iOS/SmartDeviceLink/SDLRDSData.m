//
//  SDLRDSData.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRDSData.h"

#import "SDLNames.h"


@implementation SDLRDSData

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:[dict mutableCopy]]) {
    }
    return self;
}

- (void)setProgramServiceName:(NSString *)programServiceName {
    if (programServiceName != nil) {
        [store setObject:programServiceName forKey:NAMES_PS];
    } else {
        [store removeObjectForKey:NAMES_PS];
    }
}

- (NSString *)programServiceName {
    return [store objectForKey:NAMES_PS];
}

- (void)setRadioText:(NSString *)radioText {
    if (radioText != nil) {
        [store setObject:radioText forKey:NAMES_RT];
    } else {
        [store removeObjectForKey:NAMES_RT];
    }
}

- (NSString *)radioText {
    return [store objectForKey:NAMES_RT];
}

- (void)setClockText:(NSString *)clockText {
    if (clockText != nil) {
        [store setObject:clockText forKey:NAMES_CT];
    } else {
        [store removeObjectForKey:NAMES_CT];
    }
}

- (NSString *)clockText {
    return [store objectForKey:NAMES_CT];
}

- (void)setProgramIdentification:(NSString *)programIdentification {
    if (programIdentification != nil) {
        [store setObject:programIdentification forKey:NAMES_PI];
    } else {
        [store removeObjectForKey:NAMES_PI];
    }
}

- (NSString *)programIdentification {
    return [store objectForKey:NAMES_PI];
}

- (void)setProgramType:(NSNumber *)programType {
    if (programType != nil) {
        [store setObject:programType forKey:NAMES_PTY];
    } else {
        [store removeObjectForKey:NAMES_PTY];
    }
}

- (NSNumber *)programType {
    return [store objectForKey:NAMES_PTY];
}

- (void)setOffersTrafficAnnouncements:(NSNumber *)offersTrafficAnnouncements {
    if (offersTrafficAnnouncements != nil) {
        [store setObject:offersTrafficAnnouncements forKey:NAMES_TP];
    } else {
        [store removeObjectForKey:NAMES_TP];
    }
}

- (NSNumber *)offersTrafficAnnouncements {
    return [store objectForKey:NAMES_PS];
}

- (void)setAnnouncingTraffic:(NSNumber *)announcingTraffic {
    if (announcingTraffic != nil) {
        [store setObject:announcingTraffic forKey:NAMES_TA];
    } else {
        [store removeObjectForKey:NAMES_TA];
    }
}

- (NSNumber *)announcingTraffic {
    return [store objectForKey:NAMES_TA];
}

- (void)setRegion:(NSString *)region {
    if (region != nil) {
        [store setObject:region forKey:NAMES_REG];
    } else {
        [store removeObjectForKey:NAMES_REG];
    }
}

- (NSString *)region {
    return [store objectForKey:NAMES_PS];
}

@end
