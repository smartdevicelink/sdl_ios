//  SDLRPCNotification.m
//


#import "SDLRPCNotification.h"



@implementation SDLRPCNotification

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (!self) {
        return nil;
    }

    messageType = SDLNameNotification;
    [store setObject:function forKey:messageType];

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    messageType = SDLNameNotification;
    [store setObject:function forKey:messageType];

    return self;
}

@end
