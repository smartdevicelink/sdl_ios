//  SDLAddCommand.m
//


#import "SDLAddCommand.h"

#import "SDLImage.h"
#import "SDLMenuParams.h"
#import "SDLNames.h"


@implementation SDLAddCommand

- (instancetype)init {
    if (self = [super initWithName:NAMES_AddCommand]) {
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

- (instancetype)initWithId:(NSNumber *)commandId vrCommands:(NSArray *)vrCommands handler:(SDLRPCNotificationHandler)handler {
    if (self = [self initWithId:commandId menuName:nil vrCommands:vrCommands handler:handler]) {
    }
    return self;
}

- (instancetype)initWithId:(NSNumber *)commandId menuName:(NSString *)menuName vrCommands:(NSArray *)vrCommands handler:(SDLRPCNotificationHandler)handler {
    if (self = [self initWithId:commandId menuName:menuName parentId:nil position:nil vrCommands:vrCommands iconValue:nil iconType:nil handler:handler]) {
    }
    return nil;
}

- (instancetype)initWithId:(NSNumber *)commandId menuName:(NSString *)menuName parentId:(NSNumber *)parentId position:(NSNumber *)position vrCommands:(NSArray *)vrCommands iconValue:(NSString *)iconValue iconType:(SDLImageType *)iconType handler:(SDLRPCNotificationHandler)handler {
    if (self = [self initWithHandler:handler]) {
        self.cmdID = commandId;
        
        if (menuName != nil || parentId != nil || position != nil) {
            self.menuParams = [[SDLMenuParams alloc] initWithMenuName:menuName parentId:parentId position:position];
        }
        
        self.vrCommands = [vrCommands mutableCopy];

        if (iconValue != nil || iconType != nil) {
            self.cmdIcon = [[SDLImage alloc] initWithName:iconValue ofType:iconType];
        }
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setCmdID:(NSNumber *)cmdID {
    if (cmdID != nil) {
        [parameters setObject:cmdID forKey:NAMES_cmdID];
    } else {
        [parameters removeObjectForKey:NAMES_cmdID];
    }
}

- (NSNumber *)cmdID {
    return [parameters objectForKey:NAMES_cmdID];
}

- (void)setMenuParams:(SDLMenuParams *)menuParams {
    if (menuParams != nil) {
        [parameters setObject:menuParams forKey:NAMES_menuParams];
    } else {
        [parameters removeObjectForKey:NAMES_menuParams];
    }
}

- (SDLMenuParams *)menuParams {
    NSObject *obj = [parameters objectForKey:NAMES_menuParams];
    if (obj == nil || [obj isKindOfClass:SDLMenuParams.class]) {
        return (SDLMenuParams *)obj;
    } else {
        return [[SDLMenuParams alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setVrCommands:(NSMutableArray *)vrCommands {
    if (vrCommands != nil) {
        [parameters setObject:vrCommands forKey:NAMES_vrCommands];
    } else {
        [parameters removeObjectForKey:NAMES_vrCommands];
    }
}

- (NSMutableArray *)vrCommands {
    return [parameters objectForKey:NAMES_vrCommands];
}

- (void)setCmdIcon:(SDLImage *)cmdIcon {
    if (cmdIcon != nil) {
        [parameters setObject:cmdIcon forKey:NAMES_cmdIcon];
    } else {
        [parameters removeObjectForKey:NAMES_cmdIcon];
    }
}

- (SDLImage *)cmdIcon {
    NSObject *obj = [parameters objectForKey:NAMES_cmdIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
