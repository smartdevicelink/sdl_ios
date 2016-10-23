//  SDLAddCommand.m
//


#import "SDLAddCommand.h"

#import "SDLImage.h"
#import "SDLMenuParams.h"
#import "SDLNames.h"

@implementation SDLAddCommand

- (instancetype)init {
    if (self = [super initWithName:SDLNameAddCommand]) {
    }
    return self;
}

- (instancetype)initWithHandler:(SDLRPCNotificationHandler)handler {
    self = [self init];
    if (!self) {
        return nil;
    }

    _handler = handler;

    return self;
}

- (void)setCmdID:(NSNumber<SDLInt> *)cmdID {
    if (cmdID != nil) {
        [parameters setObject:cmdID forKey:SDLNameCommandId];
    } else {
        [parameters removeObjectForKey:SDLNameCommandId];
    }
}

- (NSNumber<SDLInt> *)cmdID {
    return [parameters objectForKey:SDLNameCommandId];
}

- (void)setMenuParams:(SDLMenuParams *)menuParams {
    if (menuParams != nil) {
        [parameters setObject:menuParams forKey:SDLNameMenuParams];
    } else {
        [parameters removeObjectForKey:SDLNameMenuParams];
    }
}

- (SDLMenuParams *)menuParams {
    NSObject *obj = [parameters objectForKey:SDLNameMenuParams];
    if (obj == nil || [obj isKindOfClass:SDLMenuParams.class]) {
        return (SDLMenuParams *)obj;
    } else {
        return [[SDLMenuParams alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setVrCommands:(NSMutableArray<NSString *> *)vrCommands {
    if (vrCommands != nil) {
        [parameters setObject:vrCommands forKey:SDLNameVRCommands];
    } else {
        [parameters removeObjectForKey:SDLNameVRCommands];
    }
}

- (NSMutableArray<NSString *> *)vrCommands {
    return [parameters objectForKey:SDLNameVRCommands];
}

- (void)setCmdIcon:(SDLImage *)cmdIcon {
    if (cmdIcon != nil) {
        [parameters setObject:cmdIcon forKey:SDLNameCommandIcon];
    } else {
        [parameters removeObjectForKey:SDLNameCommandIcon];
    }
}

- (SDLImage *)cmdIcon {
    NSObject *obj = [parameters objectForKey:SDLNameCommandIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
