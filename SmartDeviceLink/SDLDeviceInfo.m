//  SDLDeviceInfo.m
//

#import "SDLDeviceInfo.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

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
    [self.store sdl_setObject:hardware forName:SDLRPCParameterNameHardware];
}

- (nullable NSString *)hardware {
    return [self.store sdl_objectForName:SDLRPCParameterNameHardware ofClass:NSString.class error:nil];
}

- (void)setFirmwareRev:(nullable NSString *)firmwareRev {
    [self.store sdl_setObject:firmwareRev forName:SDLRPCParameterNameFirmwareRevision];
}

- (nullable NSString *)firmwareRev {
    return [self.store sdl_objectForName:SDLRPCParameterNameFirmwareRevision ofClass:NSString.class error:nil];
}

- (void)setOs:(nullable NSString *)os {
    [self.store sdl_setObject:os forName:SDLRPCParameterNameOS];
}

- (nullable NSString *)os {
    return [self.store sdl_objectForName:SDLRPCParameterNameOS ofClass:NSString.class error:nil];
}

- (void)setOsVersion:(nullable NSString *)osVersion {
    [self.store sdl_setObject:osVersion forName:SDLRPCParameterNameOSVersion];
}

- (nullable NSString *)osVersion {
    return [self.store sdl_objectForName:SDLRPCParameterNameOSVersion ofClass:NSString.class error:nil];
}

- (void)setCarrier:(nullable NSString *)carrier {
    [self.store sdl_setObject:carrier forName:SDLRPCParameterNameCarrier];
}

- (nullable NSString *)carrier {
    return [self.store sdl_objectForName:SDLRPCParameterNameCarrier ofClass:NSString.class error:nil];
}

- (void)setMaxNumberRFCOMMPorts:(nullable NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    [self.store sdl_setObject:maxNumberRFCOMMPorts forName:SDLRPCParameterNameMaxNumberRFCOMMPorts];
}

- (nullable NSNumber<SDLInt> *)maxNumberRFCOMMPorts {
    return [self.store sdl_objectForName:SDLRPCParameterNameMaxNumberRFCOMMPorts ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
