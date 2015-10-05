//  SDLAppHMIType.m
//


#import "SDLAppHMIType.h"

SDLAppHMIType *SDLAppHMIType_DEFAULT = nil;
SDLAppHMIType *SDLAppHMIType_COMMUNICATION = nil;
SDLAppHMIType *SDLAppHMIType_MEDIA = nil;
SDLAppHMIType *SDLAppHMIType_MESSAGING = nil;
SDLAppHMIType *SDLAppHMIType_NAVIGATION = nil;
SDLAppHMIType *SDLAppHMIType_INFORMATION = nil;
SDLAppHMIType *SDLAppHMIType_SOCIAL = nil;
SDLAppHMIType *SDLAppHMIType_BACKGROUND_PROCESS = nil;
SDLAppHMIType *SDLAppHMIType_TESTING = nil;
SDLAppHMIType *SDLAppHMIType_SYSTEM = nil;

NSArray *SDLAppHMIType_values = nil;

@implementation SDLAppHMIType

+ (SDLAppHMIType *)valueOf:(NSString *)value {
    for (SDLAppHMIType *item in SDLAppHMIType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLAppHMIType_values == nil) {
        SDLAppHMIType_values = @[
            SDLAppHMIType.DEFAULT,
            SDLAppHMIType.COMMUNICATION,
            SDLAppHMIType.MEDIA,
            SDLAppHMIType.MESSAGING,
            SDLAppHMIType.NAVIGATION,
            SDLAppHMIType.INFORMATION,
            SDLAppHMIType.SOCIAL,
            SDLAppHMIType.BACKGROUND_PROCESS,
            SDLAppHMIType.TESTING,
            SDLAppHMIType.SYSTEM,
        ];
    }
    return SDLAppHMIType_values;
}

+ (SDLAppHMIType *)DEFAULT {
    if (SDLAppHMIType_DEFAULT == nil) {
        SDLAppHMIType_DEFAULT = [[SDLAppHMIType alloc] initWithValue:@"DEFAULT"];
    }
    return SDLAppHMIType_DEFAULT;
}

+ (SDLAppHMIType *)COMMUNICATION {
    if (SDLAppHMIType_COMMUNICATION == nil) {
        SDLAppHMIType_COMMUNICATION = [[SDLAppHMIType alloc] initWithValue:@"COMMUNICATION"];
    }
    return SDLAppHMIType_COMMUNICATION;
}

+ (SDLAppHMIType *)MEDIA {
    if (SDLAppHMIType_MEDIA == nil) {
        SDLAppHMIType_MEDIA = [[SDLAppHMIType alloc] initWithValue:@"MEDIA"];
    }
    return SDLAppHMIType_MEDIA;
}

+ (SDLAppHMIType *)MESSAGING {
    if (SDLAppHMIType_MESSAGING == nil) {
        SDLAppHMIType_MESSAGING = [[SDLAppHMIType alloc] initWithValue:@"MESSAGING"];
    }
    return SDLAppHMIType_MESSAGING;
}

+ (SDLAppHMIType *)NAVIGATION {
    if (SDLAppHMIType_NAVIGATION == nil) {
        SDLAppHMIType_NAVIGATION = [[SDLAppHMIType alloc] initWithValue:@"NAVIGATION"];
    }
    return SDLAppHMIType_NAVIGATION;
}

+ (SDLAppHMIType *)INFORMATION {
    if (SDLAppHMIType_INFORMATION == nil) {
        SDLAppHMIType_INFORMATION = [[SDLAppHMIType alloc] initWithValue:@"INFORMATION"];
    }
    return SDLAppHMIType_INFORMATION;
}

+ (SDLAppHMIType *)SOCIAL {
    if (SDLAppHMIType_SOCIAL == nil) {
        SDLAppHMIType_SOCIAL = [[SDLAppHMIType alloc] initWithValue:@"SOCIAL"];
    }
    return SDLAppHMIType_SOCIAL;
}

+ (SDLAppHMIType *)BACKGROUND_PROCESS {
    if (SDLAppHMIType_BACKGROUND_PROCESS == nil) {
        SDLAppHMIType_BACKGROUND_PROCESS = [[SDLAppHMIType alloc] initWithValue:@"BACKGROUND_PROCESS"];
    }
    return SDLAppHMIType_BACKGROUND_PROCESS;
}

+ (SDLAppHMIType *)TESTING {
    if (SDLAppHMIType_TESTING == nil) {
        SDLAppHMIType_TESTING = [[SDLAppHMIType alloc] initWithValue:@"TESTING"];
    }
    return SDLAppHMIType_TESTING;
}

+ (SDLAppHMIType *)SYSTEM {
    if (SDLAppHMIType_SYSTEM == nil) {
        SDLAppHMIType_SYSTEM = [[SDLAppHMIType alloc] initWithValue:@"SYSTEM"];
    }
    return SDLAppHMIType_SYSTEM;
}

@end
