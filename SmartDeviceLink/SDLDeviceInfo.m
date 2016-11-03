//  SDLDeviceInfo.m
//

#import "SDLDeviceInfo.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

#import "SDLNames.h"

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
    if (hardware != nil) {
        [store setObject:hardware forKey:NAMES_hardware];
    } else {
        [store removeObjectForKey:NAMES_hardware];
    }
}

- (NSString *)hardware {
    return [store objectForKey:NAMES_hardware];
}

- (void)setFirmwareRev:(NSString *)firmwareRev {
    if (firmwareRev != nil) {
        [store setObject:firmwareRev forKey:NAMES_firmwareRev];
    } else {
        [store removeObjectForKey:NAMES_firmwareRev];
    }
}

- (NSString *)firmwareRev {
    return [store objectForKey:NAMES_firmwareRev];
}

- (void)setOs:(NSString *)os {
    if (os != nil) {
        [store setObject:os forKey:NAMES_os];
    } else {
        [store removeObjectForKey:NAMES_os];
    }
}

- (NSString *)os {
    return [store objectForKey:NAMES_os];
}

- (void)setOsVersion:(NSString *)osVersion {
    if (osVersion != nil) {
        [store setObject:osVersion forKey:NAMES_osVersion];
    } else {
        [store removeObjectForKey:NAMES_osVersion];
    }
}

- (NSString *)osVersion {
    return [store objectForKey:NAMES_osVersion];
}

- (void)setCarrier:(NSString *)carrier {
    if (carrier != nil) {
        [store setObject:carrier forKey:NAMES_carrier];
    } else {
        [store removeObjectForKey:NAMES_carrier];
    }
}

- (NSString *)carrier {
    return [store objectForKey:NAMES_carrier];
}

- (void)setMaxNumberRFCOMMPorts:(NSNumber *)maxNumberRFCOMMPorts {
    if (maxNumberRFCOMMPorts != nil) {
        [store setObject:maxNumberRFCOMMPorts forKey:NAMES_maxNumberRFCOMMPorts];
    } else {
        [store removeObjectForKey:NAMES_maxNumberRFCOMMPorts];
    }
}

- (NSNumber *)maxNumberRFCOMMPorts {
    return [store objectForKey:NAMES_maxNumberRFCOMMPorts];
}

@end
