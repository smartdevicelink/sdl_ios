//  SDLAddCommand.m
//


#import "SDLAddCommand.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLMenuParams.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAddCommand

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAddCommand]) {
    }
    return self;
}
#pragma clang diagnostic pop

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

- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position iconValue:(nullable NSString *)iconValue iconType:(nullable SDLImageType)iconType iconIsTemplate:(BOOL)iconIsTemplate handler:(nullable SDLRPCCommandNotificationHandler)handler {
    self = [self initWithId:commandId vrCommands:vrCommands menuName:menuName handler:handler];
    if (!self) {
        return nil;
    }

    self.menuParams.parentID = @(parentId);
    self.menuParams.position = @(position);

    if (iconValue != nil && iconType != nil) {
        self.cmdIcon = [[SDLImage alloc] initWithName:iconValue ofType:iconType isTemplate:iconIsTemplate];
    }

    return self;
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position icon:(nullable SDLImage *)icon handler:(nullable SDLRPCCommandNotificationHandler)handler {
    self = [self initWithId:commandId vrCommands:vrCommands menuName:menuName handler:handler];
    if (!self) {
        return nil;
    }

    self.menuParams.parentID = @(parentId);
    self.menuParams.position = @(position);
    self.cmdIcon = icon;

    return self;
}

- (instancetype)initWithCmdID:(UInt32)cmdID {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.cmdID = @(cmdID);
    return self;
}

- (instancetype)initWithCmdID:(UInt32)cmdID menuParams:(nullable SDLMenuParams *)menuParams vrCommands:(nullable NSArray<NSString *> *)vrCommands cmdIcon:(nullable SDLImage *)cmdIcon secondaryImage:(nullable SDLImage *)secondaryImage {
    self = [self initWithCmdID:cmdID];
    if (!self) {
        return nil;
    }
    self.menuParams = menuParams;
    self.vrCommands = vrCommands;
    self.cmdIcon = cmdIcon;
    self.secondaryImage = secondaryImage;
    return self;
}

#pragma mark - Getters / Setters

- (void)setCmdID:(NSNumber<SDLInt> *)cmdID {
    [self.parameters sdl_setObject:cmdID forName:SDLRPCParameterNameCommandId];
}

- (NSNumber<SDLInt> *)cmdID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCommandId ofClass:NSNumber.class error:&error];
}

- (void)setMenuParams:(nullable SDLMenuParams *)menuParams {
    [self.parameters sdl_setObject:menuParams forName:SDLRPCParameterNameMenuParams];
}

- (nullable SDLMenuParams *)menuParams {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuParams ofClass:SDLMenuParams.class error:nil];
}

- (void)setVrCommands:(nullable NSArray<NSString *> *)vrCommands {
    [self.parameters sdl_setObject:vrCommands forName:SDLRPCParameterNameVRCommands];
}

- (nullable NSArray<NSString *> *)vrCommands {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameVRCommands ofClass:NSString.class error:nil];
}

- (void)setCmdIcon:(nullable SDLImage *)cmdIcon {
    [self.parameters sdl_setObject:cmdIcon forName:SDLRPCParameterNameCommandIcon];
}

- (nullable SDLImage *)cmdIcon {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCommandIcon ofClass:SDLImage.class error:nil];
}

- (void)setSecondaryImage:(nullable SDLImage *)secondaryImage {
    [self.parameters sdl_setObject:secondaryImage forName:SDLRPCParameterNameSecondaryImage];
}

- (nullable SDLImage *)secondaryImage {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSecondaryImage ofClass:SDLImage.class error:nil];
}

-(id)copyWithZone:(nullable NSZone *)zone {
    SDLAddCommand *newCommand = [super copyWithZone:zone];
    newCommand->_handler = self.handler;

    return newCommand;
}

@end

NS_ASSUME_NONNULL_END
