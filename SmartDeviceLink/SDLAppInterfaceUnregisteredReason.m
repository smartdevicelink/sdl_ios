//  SDLAppInterfaceUnregisteredReason.m
//

#import "SDLAppInterfaceUnregisteredReason.h"

SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_IGNITION_OFF = nil;
SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_BLUETOOTH_OFF = nil;
SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_USB_DISCONNECTED = nil;
SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_REQUEST_WHILE_IN_NONE_HMI_LEVEL = nil;
SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_TOO_MANY_REQUESTS = nil;
SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_DRIVER_DISTRACTION_VIOLATION = nil;
SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_LANGUAGE_CHANGE = nil;
SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_MASTER_RESET = nil;
SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_FACTORY_DEFAULTS = nil;
SDLAppInterfaceUnregisteredReason *SDLAppInterfaceUnregisteredReason_APP_UNAUTHORIZED = nil;

NSArray *SDLAppInterfaceUnregisteredReason_values = nil;

@implementation SDLAppInterfaceUnregisteredReason

+ (SDLAppInterfaceUnregisteredReason *)valueOf:(NSString *)value {
    for (SDLAppInterfaceUnregisteredReason *item in SDLAppInterfaceUnregisteredReason.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLAppInterfaceUnregisteredReason_values == nil) {
        SDLAppInterfaceUnregisteredReason_values = @[
            SDLAppInterfaceUnregisteredReason.IGNITION_OFF,
            SDLAppInterfaceUnregisteredReason.BLUETOOTH_OFF,
            SDLAppInterfaceUnregisteredReason.USB_DISCONNECTED,
            SDLAppInterfaceUnregisteredReason.REQUEST_WHILE_IN_NONE_HMI_LEVEL,
            SDLAppInterfaceUnregisteredReason.TOO_MANY_REQUESTS,
            SDLAppInterfaceUnregisteredReason.DRIVER_DISTRACTION_VIOLATION,
            SDLAppInterfaceUnregisteredReason.LANGUAGE_CHANGE,
            SDLAppInterfaceUnregisteredReason.MASTER_RESET,
            SDLAppInterfaceUnregisteredReason.FACTORY_DEFAULTS,
            SDLAppInterfaceUnregisteredReason.APP_UNAUTHORIZED,
        ];
    }
    return SDLAppInterfaceUnregisteredReason_values;
}

+ (SDLAppInterfaceUnregisteredReason *)IGNITION_OFF {
    if (SDLAppInterfaceUnregisteredReason_IGNITION_OFF == nil) {
        SDLAppInterfaceUnregisteredReason_IGNITION_OFF = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"IGNITION_OFF"];
    }
    return SDLAppInterfaceUnregisteredReason_IGNITION_OFF;
}

+ (SDLAppInterfaceUnregisteredReason *)BLUETOOTH_OFF {
    if (SDLAppInterfaceUnregisteredReason_BLUETOOTH_OFF == nil) {
        SDLAppInterfaceUnregisteredReason_BLUETOOTH_OFF = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"BLUETOOTH_OFF"];
    }
    return SDLAppInterfaceUnregisteredReason_BLUETOOTH_OFF;
}

+ (SDLAppInterfaceUnregisteredReason *)USB_DISCONNECTED {
    if (SDLAppInterfaceUnregisteredReason_USB_DISCONNECTED == nil) {
        SDLAppInterfaceUnregisteredReason_USB_DISCONNECTED = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"USB_DISCONNECTED"];
    }
    return SDLAppInterfaceUnregisteredReason_USB_DISCONNECTED;
}

+ (SDLAppInterfaceUnregisteredReason *)REQUEST_WHILE_IN_NONE_HMI_LEVEL {
    if (SDLAppInterfaceUnregisteredReason_REQUEST_WHILE_IN_NONE_HMI_LEVEL == nil) {
        SDLAppInterfaceUnregisteredReason_REQUEST_WHILE_IN_NONE_HMI_LEVEL = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"REQUEST_WHILE_IN_NONE_HMI_LEVEL"];
    }
    return SDLAppInterfaceUnregisteredReason_REQUEST_WHILE_IN_NONE_HMI_LEVEL;
}

+ (SDLAppInterfaceUnregisteredReason *)TOO_MANY_REQUESTS {
    if (SDLAppInterfaceUnregisteredReason_TOO_MANY_REQUESTS == nil) {
        SDLAppInterfaceUnregisteredReason_TOO_MANY_REQUESTS = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"TOO_MANY_REQUESTS"];
    }
    return SDLAppInterfaceUnregisteredReason_TOO_MANY_REQUESTS;
}

+ (SDLAppInterfaceUnregisteredReason *)DRIVER_DISTRACTION_VIOLATION {
    if (SDLAppInterfaceUnregisteredReason_DRIVER_DISTRACTION_VIOLATION == nil) {
        SDLAppInterfaceUnregisteredReason_DRIVER_DISTRACTION_VIOLATION = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"DRIVER_DISTRACTION_VIOLATION"];
    }
    return SDLAppInterfaceUnregisteredReason_DRIVER_DISTRACTION_VIOLATION;
}

+ (SDLAppInterfaceUnregisteredReason *)LANGUAGE_CHANGE {
    if (SDLAppInterfaceUnregisteredReason_LANGUAGE_CHANGE == nil) {
        SDLAppInterfaceUnregisteredReason_LANGUAGE_CHANGE = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"LANGUAGE_CHANGE"];
    }
    return SDLAppInterfaceUnregisteredReason_LANGUAGE_CHANGE;
}

+ (SDLAppInterfaceUnregisteredReason *)MASTER_RESET {
    if (SDLAppInterfaceUnregisteredReason_MASTER_RESET == nil) {
        SDLAppInterfaceUnregisteredReason_MASTER_RESET = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"MASTER_RESET"];
    }
    return SDLAppInterfaceUnregisteredReason_MASTER_RESET;
}

+ (SDLAppInterfaceUnregisteredReason *)FACTORY_DEFAULTS {
    if (SDLAppInterfaceUnregisteredReason_FACTORY_DEFAULTS == nil) {
        SDLAppInterfaceUnregisteredReason_FACTORY_DEFAULTS = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"FACTORY_DEFAULTS"];
    }
    return SDLAppInterfaceUnregisteredReason_FACTORY_DEFAULTS;
}

+ (SDLAppInterfaceUnregisteredReason *)APP_UNAUTHORIZED {
    if (SDLAppInterfaceUnregisteredReason_APP_UNAUTHORIZED == nil) {
        SDLAppInterfaceUnregisteredReason_APP_UNAUTHORIZED = [[SDLAppInterfaceUnregisteredReason alloc] initWithValue:@"APP_UNAUTHORIZED"];
    }
    return SDLAppInterfaceUnregisteredReason_APP_UNAUTHORIZED;
}

@end
