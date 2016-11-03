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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(NSArray<NSString *> *)vrCommands handler:(SDLRPCNotificationHandler)handler {
    return [self initWithId:commandId vrCommands:vrCommands menuName:nil handler:handler];
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName handler:(SDLRPCNotificationHandler)handler {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.cmdID = @(commandId);

    if (menuName != nil) {
        self.menuParams = [[SDLMenuParams alloc] initWithMenuName:menuName];
    }

    self.vrCommands = [vrCommands mutableCopy];
    self.handler = handler;

    return self;
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position iconValue:(NSString *)iconValue iconType:(SDLImageType *)iconType handler:(SDLRPCNotificationHandler)handler {
    self = [self initWithId:commandId vrCommands:vrCommands menuName:menuName handler:handler];
    if (!self) {
        return nil;
    }

    self.menuParams.parentID = @(parentId);
    self.menuParams.position = @(position);

    if (iconValue != nil && iconType != nil) {
        self.cmdIcon = [[SDLImage alloc] initWithName:iconValue ofType:iconType];
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
