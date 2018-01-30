//  SDLAddCommand.m
//


#import "SDLAddCommand.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLMenuParams.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAddCommand

- (instancetype)init {
    if (self = [super initWithName:SDLNameAddCommand]) {
    }
    return self;
}

- (instancetype)initWithHandler:(nullable SDLRPCCommandNotificationHandler)handler {
    self = [self init];
    if (!self) {
        return nil;
    }

    _handler = handler;

    return self;
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands handler:(nullable SDLRPCCommandNotificationHandler)handler {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.cmdID = @(commandId);
    self.vrCommands = [vrCommands mutableCopy];
    self.handler = handler;
    
    return self;
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName handler:(nullable SDLRPCCommandNotificationHandler)handler {
    self = [self initWithId:commandId vrCommands:vrCommands handler:handler];
    if (!self) {
        return nil;
    }
    
    self.menuParams = [[SDLMenuParams alloc] initWithMenuName:menuName];
    
    return self;
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position iconValue:(nullable NSString *)iconValue iconType:(nullable SDLImageType)iconType handler:(nullable SDLRPCCommandNotificationHandler)handler {
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

- (void)setMenuParams:(nullable SDLMenuParams *)menuParams {
    [parameters sdl_setObject:menuParams forName:SDLNameMenuParams];
}

- (nullable SDLMenuParams *)menuParams {
    return [parameters sdl_objectForName:SDLNameMenuParams ofClass:SDLMenuParams.class];
}

- (void)setVrCommands:(nullable NSArray<NSString *> *)vrCommands {
    [parameters sdl_setObject:vrCommands forName:SDLNameVRCommands];
}

- (nullable NSArray<NSString *> *)vrCommands {
    return [parameters sdl_objectForName:SDLNameVRCommands];
}

- (void)setCmdIcon:(nullable SDLImage *)cmdIcon {
    [parameters sdl_setObject:cmdIcon forName:SDLNameCommandIcon];
}

- (nullable SDLImage *)cmdIcon {
    return [parameters sdl_objectForName:SDLNameCommandIcon ofClass:SDLImage.class];
}

-(id)copyWithZone:(nullable NSZone *)zone {
    SDLAddCommand *newCommand = [super copyWithZone:zone];
    newCommand->_handler = self.handler;

    return newCommand;
}

@end

NS_ASSUME_NONNULL_END
