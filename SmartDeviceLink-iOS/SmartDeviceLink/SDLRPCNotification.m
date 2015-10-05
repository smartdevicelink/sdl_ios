//  SDLRPCNotification.m
//


#import "SDLRPCNotification.h"

#import "SDLNames.h"

@implementation SDLRPCNotification

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (!self) {
        return nil;
    }

    messageType = NAMES_notification;
    [store setObject:function forKey:messageType];

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    messageType = NAMES_notification;
    [store setObject:function forKey:messageType];

    return self;
}

@end
