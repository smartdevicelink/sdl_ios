//  SDLRequestType.m
//


#import "SDLRequestType.h"

SDLRequestType *SDLRequestType_HTTP = nil;
SDLRequestType *SDLRequestType_FILE_RESUME = nil;
SDLRequestType *SDLRequestType_AUTH_REQUEST = nil;
SDLRequestType *SDLRequestType_AUTH_CHALLENGE = nil;
SDLRequestType *SDLRequestType_AUTH_ACK = nil;
SDLRequestType *SDLRequestType_PROPRIETARY = nil;
SDLRequestType *SDLRequestType_QUERY_APPS = nil;
SDLRequestType *SDLRequestType_LAUNCH_APP = nil;
SDLRequestType *SDLRequestType_LOCK_SCREEN_ICON_URL = nil;
SDLRequestType *SDLRequestType_TRAFFIC_MESSAGE_CHANNEL = nil;
SDLRequestType *SDLRequestType_DRIVER_PROFILE = nil;
SDLRequestType *SDLRequestType_VOICE_SEARCH = nil;
SDLRequestType *SDLRequestType_NAVIGATION = nil;
SDLRequestType *SDLRequestType_PHONE = nil;
SDLRequestType *SDLRequestType_CLIMATE = nil;
SDLRequestType *SDLRequestType_SETTINGS = nil;
SDLRequestType *SDLRequestType_VEHICLE_DIAGNOSTICS = nil;
SDLRequestType *SDLRequestType_EMERGENCY = nil;
SDLRequestType *SDLRequestType_MEDIA = nil;
SDLRequestType *SDLRequestType_FOTA = nil;

NSArray *SDLRequestType_values = nil;


@implementation SDLRequestType

+ (SDLRequestType *)valueOf:(NSString *)value {
    for (SDLRequestType *item in SDLRequestType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLRequestType_values == nil) {
        SDLRequestType_values = @[
            [SDLRequestType HTTP],
            [SDLRequestType FILE_RESUME],
            [SDLRequestType AUTH_REQUEST],
            [SDLRequestType AUTH_CHALLENGE],
            [SDLRequestType AUTH_ACK],
            [SDLRequestType PROPRIETARY],
            [SDLRequestType QUERY_APPS],
            [SDLRequestType LAUNCH_APP],
            [SDLRequestType LOCK_SCREEN_ICON_URL],
            [SDLRequestType TRAFFIC_MESSAGE_CHANNEL],
            [SDLRequestType DRIVER_PROFILE],
            [SDLRequestType VOICE_SEARCH],
            [SDLRequestType NAVIGATION],
            [SDLRequestType PHONE],
            [SDLRequestType CLIMATE],
            [SDLRequestType SETTINGS],
            [SDLRequestType VEHICLE_DIAGNOSTICS],
            [SDLRequestType EMERGENCY],
            [SDLRequestType MEDIA],
            [SDLRequestType FOTA],
        ];
    }
    return SDLRequestType_values;
}

+ (SDLRequestType *)HTTP {
    if (SDLRequestType_HTTP == nil) {
        SDLRequestType_HTTP = [[SDLRequestType alloc] initWithValue:@"HTTP"];
    }
    return SDLRequestType_HTTP;
}

+ (SDLRequestType *)FILE_RESUME {
    if (SDLRequestType_FILE_RESUME == nil) {
        SDLRequestType_FILE_RESUME = [[SDLRequestType alloc] initWithValue:@"FILE_RESUME"];
    }
    return SDLRequestType_FILE_RESUME;
}

+ (SDLRequestType *)AUTH_REQUEST {
    if (SDLRequestType_AUTH_REQUEST == nil) {
        SDLRequestType_AUTH_REQUEST = [[SDLRequestType alloc] initWithValue:@"AUTH_REQUEST"];
    }
    return SDLRequestType_AUTH_REQUEST;
}

+ (SDLRequestType *)AUTH_CHALLENGE {
    if (SDLRequestType_AUTH_CHALLENGE == nil) {
        SDLRequestType_AUTH_CHALLENGE = [[SDLRequestType alloc] initWithValue:@"AUTH_CHALLENGE"];
    }
    return SDLRequestType_AUTH_CHALLENGE;
}

+ (SDLRequestType *)AUTH_ACK {
    if (SDLRequestType_AUTH_ACK == nil) {
        SDLRequestType_AUTH_ACK = [[SDLRequestType alloc] initWithValue:@"AUTH_ACK"];
    }
    return SDLRequestType_AUTH_ACK;
}

+ (SDLRequestType *)PROPRIETARY {
    if (SDLRequestType_PROPRIETARY == nil) {
        SDLRequestType_PROPRIETARY = [[SDLRequestType alloc] initWithValue:@"PROPRIETARY"];
    }
    return SDLRequestType_PROPRIETARY;
}

+ (SDLRequestType *)QUERY_APPS {
    if (SDLRequestType_QUERY_APPS == nil) {
        SDLRequestType_QUERY_APPS = [[SDLRequestType alloc] initWithValue:@"QUERY_APPS"];
    }
    return SDLRequestType_QUERY_APPS;
}

+ (SDLRequestType *)LAUNCH_APP {
    if (SDLRequestType_LAUNCH_APP == nil) {
        SDLRequestType_LAUNCH_APP = [[SDLRequestType alloc] initWithValue:@"LAUNCH_APP"];
    }
    return SDLRequestType_LAUNCH_APP;
}

+ (SDLRequestType *)LOCK_SCREEN_ICON_URL {
    if (SDLRequestType_LOCK_SCREEN_ICON_URL == nil) {
        SDLRequestType_LOCK_SCREEN_ICON_URL = [[SDLRequestType alloc] initWithValue:@"LOCK_SCREEN_ICON_URL"];
    }
    return SDLRequestType_LOCK_SCREEN_ICON_URL;
}

+ (SDLRequestType *)TRAFFIC_MESSAGE_CHANNEL {
    if (SDLRequestType_TRAFFIC_MESSAGE_CHANNEL == nil) {
        SDLRequestType_TRAFFIC_MESSAGE_CHANNEL = [[SDLRequestType alloc] initWithValue:@"TRAFFIC_MESSAGE_CHANNEL"];
    }
    return SDLRequestType_TRAFFIC_MESSAGE_CHANNEL;
}

+ (SDLRequestType *)DRIVER_PROFILE {
    if (SDLRequestType_DRIVER_PROFILE == nil) {
        SDLRequestType_DRIVER_PROFILE = [[SDLRequestType alloc] initWithValue:@"DRIVER_PROFILE"];
    }
    return SDLRequestType_DRIVER_PROFILE;
}

+ (SDLRequestType *)VOICE_SEARCH {
    if (SDLRequestType_VOICE_SEARCH == nil) {
        SDLRequestType_VOICE_SEARCH = [[SDLRequestType alloc] initWithValue:@"VOICE_SEARCH"];
    }
    return SDLRequestType_VOICE_SEARCH;
}

+ (SDLRequestType *)NAVIGATION {
    if (SDLRequestType_NAVIGATION == nil) {
        SDLRequestType_NAVIGATION = [[SDLRequestType alloc] initWithValue:@"NAVIGATION"];
    }
    return SDLRequestType_NAVIGATION;
}

+ (SDLRequestType *)PHONE {
    if (SDLRequestType_PHONE == nil) {
        SDLRequestType_PHONE = [[SDLRequestType alloc] initWithValue:@"PHONE"];
    }
    return SDLRequestType_PHONE;
}

+ (SDLRequestType *)CLIMATE {
    if (SDLRequestType_CLIMATE == nil) {
        SDLRequestType_CLIMATE = [[SDLRequestType alloc] initWithValue:@"CLIMATE"];
    }
    return SDLRequestType_CLIMATE;
}

+ (SDLRequestType *)SETTINGS {
    if (SDLRequestType_SETTINGS == nil) {
        SDLRequestType_SETTINGS = [[SDLRequestType alloc] initWithValue:@"SETTINGS"];
    }
    return SDLRequestType_SETTINGS;
}

+ (SDLRequestType *)VEHICLE_DIAGNOSTICS {
    if (SDLRequestType_VEHICLE_DIAGNOSTICS == nil) {
        SDLRequestType_VEHICLE_DIAGNOSTICS = [[SDLRequestType alloc] initWithValue:@"VEHICLE_DIAGNOSTICS"];
    }
    return SDLRequestType_VEHICLE_DIAGNOSTICS;
}

+ (SDLRequestType *)EMERGENCY {
    if (SDLRequestType_EMERGENCY == nil) {
        SDLRequestType_EMERGENCY = [[SDLRequestType alloc] initWithValue:@"EMERGENCY"];
    }
    return SDLRequestType_EMERGENCY;
}

+ (SDLRequestType *)MEDIA {
    if (SDLRequestType_MEDIA == nil) {
        SDLRequestType_MEDIA = [[SDLRequestType alloc] initWithValue:@"MEDIA"];
    }
    return SDLRequestType_MEDIA;
}

+ (SDLRequestType *)FOTA {
    if (SDLRequestType_FOTA == nil) {
        SDLRequestType_FOTA = [[SDLRequestType alloc] initWithValue:@"FOTA"];
    }
    return SDLRequestType_FOTA;
}

@end
