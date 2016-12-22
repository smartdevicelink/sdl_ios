//  SDLAddCommand.m
//


#import "SDLAddCommand.h"

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

- (instancetype)initWithHandler:(nullable SDLRPCNotificationHandler)handler {
    self = [self init];
    if (!self) {
        return nil;
    }

    _handler = handler;

    return self;
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands handler:(nullable SDLRPCNotificationHandler)handler {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.cmdID = @(commandId);
    self.vrCommands = [vrCommands mutableCopy];
    self.handler = handler;
    
    return self;
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName handler:(SDLRPCNotificationHandler)handler {
    self = [self initWithId:commandId vrCommands:vrCommands handler:handler];
    if (!self) {
        return nil;
    }
    
    self.menuParams = [[SDLMenuParams alloc] initWithMenuName:menuName];
    
    return self;
}

- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position iconValue:(NSString *)iconValue iconType:(SDLImageType)iconType handler:(nullable SDLRPCNotificationHandler)handler {
    self = [self initWithId:commandId vrCommands:vrCommands menuName:menuName handler:handler];
    if (!self) {
        return nil;
    }

    self.menuParams.parentID = @(parentId);
    self.menuParams.position = @(position);

    self.cmdIcon = [[SDLImage alloc] initWithName:iconValue ofType:iconType];

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

- (void)setMenuParams:(nullable SDLMenuParams *)menuParams {
    if (menuParams != nil) {
        [parameters setObject:menuParams forKey:SDLNameMenuParams];
    } else {
        [parameters removeObjectForKey:SDLNameMenuParams];
    }
}

- (nullable SDLMenuParams *)menuParams {
    NSObject *obj = [parameters objectForKey:SDLNameMenuParams];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLMenuParams alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLMenuParams*)obj;
}

- (void)setVrCommands:(nullable NSMutableArray<NSString *> *)vrCommands {
    if (vrCommands != nil) {
        [parameters setObject:vrCommands forKey:SDLNameVRCommands];
    } else {
        [parameters removeObjectForKey:SDLNameVRCommands];
    }
}

- (nullable NSMutableArray<NSString *> *)vrCommands {
    return [parameters objectForKey:SDLNameVRCommands];
}

- (void)setCmdIcon:(nullable SDLImage *)cmdIcon {
    if (cmdIcon != nil) {
        [parameters setObject:cmdIcon forKey:SDLNameCommandIcon];
    } else {
        [parameters removeObjectForKey:SDLNameCommandIcon];
    }
}

- (nullable SDLImage *)cmdIcon {
    NSObject *obj = [parameters objectForKey:SDLNameCommandIcon];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLImage*)obj;
}

@end

NS_ASSUME_NONNULL_END
