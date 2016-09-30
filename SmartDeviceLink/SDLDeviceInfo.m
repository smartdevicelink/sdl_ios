//  SDLDeviceInfo.m
//

#import "SDLDeviceInfo.h"

#import "SDLNames.h"

@implementation SDLDeviceInfo

- (void)setHardware:(NSString *)hardware {
    if (hardware != nil) {
        [store setObject:hardware forKey:SDLNameHardware];
    } else {
        [store removeObjectForKey:SDLNameHardware];
    }
}

- (NSString *)hardware {
    return [store objectForKey:SDLNameHardware];
}

- (void)setFirmwareRev:(NSString *)firmwareRev {
    if (firmwareRev != nil) {
        [store setObject:firmwareRev forKey:SDLNameFirmwareRevision];
    } else {
        [store removeObjectForKey:SDLNameFirmwareRevision];
    }
}

- (NSString *)firmwareRev {
    return [store objectForKey:SDLNameFirmwareRevision];
}

- (void)setOs:(NSString *)os {
    if (os != nil) {
        [store setObject:os forKey:SDLNameOS];
    } else {
        [store removeObjectForKey:SDLNameOS];
    }
}

- (NSString *)os {
    return [store objectForKey:SDLNameOS];
}

- (void)setOsVersion:(NSString *)osVersion {
    if (osVersion != nil) {
        [store setObject:osVersion forKey:SDLNameOSVersion];
    } else {
        [store removeObjectForKey:SDLNameOSVersion];
    }
}

- (NSString *)osVersion {
    return [store objectForKey:SDLNameOSVersion];
}

- (void)setCarrier:(NSString *)carrier {
    if (carrier != nil) {
        [store setObject:carrier forKey:SDLNameCarrier];
    } else {
        [store removeObjectForKey:SDLNameCarrier];
    }
}

- (NSString *)carrier {
    return [store objectForKey:SDLNameCarrier];
}

- (void)setMaxNumberRFCOMMPorts:(NSNumber *)maxNumberRFCOMMPorts {
    if (maxNumberRFCOMMPorts != nil) {
        [store setObject:maxNumberRFCOMMPorts forKey:SDLNameMaxNumberRFCOMMPorts];
    } else {
        [store removeObjectForKey:SDLNameMaxNumberRFCOMMPorts];
    }
}

- (NSNumber *)maxNumberRFCOMMPorts {
    return [store objectForKey:SDLNameMaxNumberRFCOMMPorts];
}

@end
