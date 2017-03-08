//  SDLDeviceInfo.m
//

#import "SDLDeviceInfo.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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

- (void)setHardware:(nullable NSString *)hardware {
    [store sdl_setObject:hardware forName:SDLNameHardware];
}

- (nullable NSString *)hardware {
    return [store sdl_objectForName:SDLNameHardware];
}

- (void)setFirmwareRev:(nullable NSString *)firmwareRev {
    [store sdl_setObject:firmwareRev forName:SDLNameFirmwareRevision];
}

- (nullable NSString *)firmwareRev {
    return [store sdl_objectForName:SDLNameFirmwareRevision];
}

- (void)setOs:(nullable NSString *)os {
    [store sdl_setObject:os forName:SDLNameOS];
}

- (nullable NSString *)os {
    return [store sdl_objectForName:SDLNameOS];
}

- (void)setOsVersion:(nullable NSString *)osVersion {
    [store sdl_setObject:osVersion forName:SDLNameOSVersion];
}

- (nullable NSString *)osVersion {
    return [store sdl_objectForName:SDLNameOSVersion];
}

- (void)setCarrier:(nullable NSString *)carrier {
    [store sdl_setObject:carrier forName:SDLNameCarrier];
}

- (nullable NSString *)carrier {
    return [store sdl_objectForName:SDLNameCarrier];
}

- (void)setMaxNumberRFCOMMPorts:(nullable NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    [store sdl_setObject:maxNumberRFCOMMPorts forName:SDLNameMaxNumberRFCOMMPorts];
}

- (nullable NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    return [store sdl_objectForName:SDLNameMaxNumberRFCOMMPorts];
}

@end

NS_ASSUME_NONNULL_END
