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

- (instancetype)initWithId:(UInt32)commandId vrCommands:(NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position iconValue:(NSString *)iconValue iconType:(SDLImageType)iconType handler:(SDLRPCNotificationHandler)handler {
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

- (void)setCmdID:(NSNumber<SDLInt> *)cmdID {
    [parameters sdl_setObject:cmdID forName:SDLNameCommandId];
}

- (NSNumber<SDLInt> *)cmdID {
    return [parameters sdl_objectForName:SDLNameCommandId];
}

- (void)setMenuParams:(SDLMenuParams *)menuParams {
    [parameters sdl_setObject:menuParams forName:SDLNameMenuParams];
}

- (SDLMenuParams *)menuParams {
    return [parameters sdl_objectForName:SDLNameMenuParams ofClass:SDLMenuParams.class];
}

- (void)setVrCommands:(NSMutableArray<NSString *> *)vrCommands {
    [parameters sdl_setObject:vrCommands forName:SDLNameVRCommands];
}

- (NSMutableArray<NSString *> *)vrCommands {
    return [parameters sdl_objectForName:SDLNameVRCommands];
}

- (void)setCmdIcon:(SDLImage *)cmdIcon {
    [parameters sdl_setObject:cmdIcon forName:SDLNameCommandIcon];
}

- (SDLImage *)cmdIcon {
    return [parameters sdl_objectForName:SDLNameCommandIcon ofClass:SDLImage.class];
}

@end
