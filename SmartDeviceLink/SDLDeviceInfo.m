//  SDLDeviceInfo.m
//

#import "SDLDeviceInfo.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

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
    [self setObject:hardware forName:SDLNameHardware];
}

- (NSString *)hardware {
    return [self objectForName:SDLNameHardware];
}

- (void)setFirmwareRev:(NSString *)firmwareRev {
    [self setObject:firmwareRev forName:SDLNameFirmwareRevision];
}

- (NSString *)firmwareRev {
    return [self objectForName:SDLNameFirmwareRevision];
}

- (void)setOs:(NSString *)os {
    [self setObject:os forName:SDLNameOS];
}

- (NSString *)os {
    return [self objectForName:SDLNameOS];
}

- (void)setOsVersion:(NSString *)osVersion {
    [self setObject:osVersion forName:SDLNameOSVersion];
}

- (NSString *)osVersion {
    return [self objectForName:SDLNameOSVersion];
}

- (void)setCarrier:(NSString *)carrier {
    [self setObject:carrier forName:SDLNameCarrier];
}

- (NSString *)carrier {
    return [self objectForName:SDLNameCarrier];
}

- (void)setMaxNumberRFCOMMPorts:(NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    [self setObject:maxNumberRFCOMMPorts forName:SDLNameMaxNumberRFCOMMPorts];
}

- (NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    return [self objectForName:SDLNameMaxNumberRFCOMMPorts];
}

@end
