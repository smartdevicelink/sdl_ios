//  SDLOnAppInterfaceUnregistered.m
//

#import "SDLOnAppInterfaceUnregistered.h"

#import "SDLAppInterfaceUnregisteredReason.h"
#import "SDLNames.h"

@implementation SDLOnAppInterfaceUnregistered

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnAppInterfaceUnregistered]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setReason:(SDLAppInterfaceUnregisteredReason *)reason {
    if (reason != nil) {
        [parameters setObject:reason forKey:SDLNameReason];
    } else {
        [parameters removeObjectForKey:SDLNameReason];
    }
}

- (SDLAppInterfaceUnregisteredReason *)reason {
    NSObject *obj = [parameters objectForKey:SDLNameReason];
    if (obj == nil || [obj isKindOfClass:SDLAppInterfaceUnregisteredReason.class]) {
        return (SDLAppInterfaceUnregisteredReason *)obj;
    } else {
        return [SDLAppInterfaceUnregisteredReason valueOf:(NSString *)obj];
    }
}

@end
