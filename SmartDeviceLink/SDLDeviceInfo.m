//  SDLDeviceInfo.m
//

#import "SDLDeviceInfo.h"




@implementation SDLDeviceInfo

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

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
        [store setObject:firmwareRev forKey:SDLNameFirmwareRev];
    } else {
        [store removeObjectForKey:SDLNameFirmwareRev];
    }
}

- (NSString *)firmwareRev {
    return [store objectForKey:SDLNameFirmwareRev];
}

- (void)setOs:(NSString *)os {
    if (os != nil) {
        [store setObject:os forKey:SDLNameOs];
    } else {
        [store removeObjectForKey:SDLNameOs];
    }
}

- (NSString *)os {
    return [store objectForKey:SDLNameOs];
}

- (void)setOsVersion:(NSString *)osVersion {
    if (osVersion != nil) {
        [store setObject:osVersion forKey:SDLNameOsVersion];
    } else {
        [store removeObjectForKey:SDLNameOsVersion];
    }
}

- (NSString *)osVersion {
    return [store objectForKey:SDLNameOsVersion];
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
        [store setObject:maxNumberRFCOMMPorts forKey:SDLNameMaxNumberRfcommPorts];
    } else {
        [store removeObjectForKey:SDLNameMaxNumberRfcommPorts];
    }
}

- (NSNumber *)maxNumberRFCOMMPorts {
    return [store objectForKey:SDLNameMaxNumberRfcommPorts];
}

@end
