//  SDLDeviceInfo.m
//

#import "SDLDeviceInfo.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

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
    if (hardware != nil) {
        [store setObject:hardware forKey:SDLNameHardware];
    } else {
        [store removeObjectForKey:SDLNameHardware];
    }
}

- (nullable NSString *)hardware {
    return [store objectForKey:SDLNameHardware];
}

- (void)setFirmwareRev:(nullable NSString *)firmwareRev {
    if (firmwareRev != nil) {
        [store setObject:firmwareRev forKey:SDLNameFirmwareRevision];
    } else {
        [store removeObjectForKey:SDLNameFirmwareRevision];
    }
}

- (nullable NSString *)firmwareRev {
    return [store objectForKey:SDLNameFirmwareRevision];
}

- (void)setOs:(nullable NSString *)os {
    if (os != nil) {
        [store setObject:os forKey:SDLNameOS];
    } else {
        [store removeObjectForKey:SDLNameOS];
    }
}

- (nullable NSString *)os {
    return [store objectForKey:SDLNameOS];
}

- (void)setOsVersion:(nullable NSString *)osVersion {
    if (osVersion != nil) {
        [store setObject:osVersion forKey:SDLNameOSVersion];
    } else {
        [store removeObjectForKey:SDLNameOSVersion];
    }
}

- (nullable NSString *)osVersion {
    return [store objectForKey:SDLNameOSVersion];
}

- (void)setCarrier:(nullable NSString *)carrier {
    if (carrier != nil) {
        [store setObject:carrier forKey:SDLNameCarrier];
    } else {
        [store removeObjectForKey:SDLNameCarrier];
    }
}

- (nullable NSString *)carrier {
    return [store objectForKey:SDLNameCarrier];
}

- (void)setMaxNumberRFCOMMPorts:(nullable NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    if (maxNumberRFCOMMPorts != nil) {
        [store setObject:maxNumberRFCOMMPorts forKey:SDLNameMaxNumberRFCOMMPorts];
    } else {
        [store removeObjectForKey:SDLNameMaxNumberRFCOMMPorts];
    }
}

- (nullable NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    return [store objectForKey:SDLNameMaxNumberRFCOMMPorts];
}

@end

NS_ASSUME_NONNULL_END
