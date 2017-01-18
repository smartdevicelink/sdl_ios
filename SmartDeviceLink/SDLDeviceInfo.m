//  SDLDeviceInfo.m
//

#import "SDLDeviceInfo.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

@implementation SDLDeviceInfo

+ (instancetype)currentDevice {
    static SDLDeviceInfo *deviceInfo = nil;
    if (deviceInfo == nil) {
        deviceInfo = [[SDLDeviceInfo alloc] init];
        deviceInfo.hardware = [UIDevice currentDevice].model;
        deviceInfo.os = [UIDevice currentDevice].systemName;
        deviceInfo.osVersion = [UIDevice currentDevice].systemVersion;
        CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = netinfo.subscriberCellularProvider;
        NSString *carrierName = carrier.carrierName;
        deviceInfo.carrier = carrierName;
    }
    return deviceInfo;
}

- (void)setHardware:(NSString *)hardware {
    [store sdl_setObject:hardware forName:SDLNameHardware];
}

- (NSString *)hardware {
    return [store sdl_objectForName:SDLNameHardware];
}

- (void)setFirmwareRev:(NSString *)firmwareRev {
    [store sdl_setObject:firmwareRev forName:SDLNameFirmwareRevision];
}

- (NSString *)firmwareRev {
    return [store sdl_objectForName:SDLNameFirmwareRevision];
}

- (void)setOs:(NSString *)os {
    [store sdl_setObject:os forName:SDLNameOS];
}

- (NSString *)os {
    return [store sdl_objectForName:SDLNameOS];
}

- (void)setOsVersion:(NSString *)osVersion {
    [store sdl_setObject:osVersion forName:SDLNameOSVersion];
}

- (NSString *)osVersion {
    return [store sdl_objectForName:SDLNameOSVersion];
}

- (void)setCarrier:(NSString *)carrier {
    [store sdl_setObject:carrier forName:SDLNameCarrier];
}

- (NSString *)carrier {
    return [store sdl_objectForName:SDLNameCarrier];
}

- (void)setMaxNumberRFCOMMPorts:(NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    [store sdl_setObject:maxNumberRFCOMMPorts forName:SDLNameMaxNumberRFCOMMPorts];
}

- (NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    return [store sdl_objectForName:SDLNameMaxNumberRFCOMMPorts];
}

@end
