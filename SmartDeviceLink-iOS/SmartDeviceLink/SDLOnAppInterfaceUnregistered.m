//  SDLOnAppInterfaceUnregistered.m
//

#import "SDLOnAppInterfaceUnregistered.h"

#import "SDLAppInterfaceUnregisteredReason.h"
#import "SDLNames.h"


@implementation SDLOnAppInterfaceUnregistered

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnAppInterfaceUnregistered]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setReason:(SDLAppInterfaceUnregisteredReason *)reason {
    if (reason != nil) {
        [parameters setObject:reason forKey:NAMES_reason];
    } else {
        [parameters removeObjectForKey:NAMES_reason];
    }
}

- (SDLAppInterfaceUnregisteredReason *)reason {
    NSObject *obj = [parameters objectForKey:NAMES_reason];
    if (obj == nil || [obj isKindOfClass:SDLAppInterfaceUnregisteredReason.class]) {
        return (SDLAppInterfaceUnregisteredReason *)obj;
    } else {
        return [SDLAppInterfaceUnregisteredReason valueOf:(NSString *)obj];
    }
}

@end
