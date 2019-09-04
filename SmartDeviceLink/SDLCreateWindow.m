//
//  SDLCreateWindow.m
//  SmartDeviceLink

#import "SDLCreateWindow.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLCreateWindow

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameCreateWindow]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithId:(NSUInteger)windowId windowName:(NSString *)windowName windowType:(SDLWindowType)windowType {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.windowID = @(windowId);
    self.windowName = windowName;
    self.type = windowType;
    return self;
}

- (instancetype)initWithId:(NSUInteger)windowId windowName:(NSString *)windowName windowType:(SDLWindowType)windowType associatedServiceType:(nullable NSString *)associatedServiceType duplicateUpdatesFromWindowID:(NSUInteger)duplicateUpdatesFromWindowID {
    self = [self initWithId:windowId windowName:windowName windowType:windowType];
    if (!self) {
        return nil;
    }
    self.associatedServiceType = associatedServiceType;
    self.duplicateUpdatesFromWindowID = @(duplicateUpdatesFromWindowID);
    return self;
}


#pragma mark - Getters / Setters

- (void)setWindowID:(NSNumber<SDLUInt> *)windowID {
    [self.parameters sdl_setObject:windowID forName:SDLRPCParameterNameWindowId];
}

- (NSNumber<SDLUInt> *)windowID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWindowId ofClass:NSNumber.class error:&error];
}

- (void)setWindowName:(NSString *)windowName {
    [self.parameters sdl_setObject:windowName forName:SDLRPCParameterNameWindowName];
}

- (NSString *)windowName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWindowName ofClass:NSString.class error:&error];
}


- (void)setType:(SDLWindowType)type {
    [self.parameters sdl_setObject:type forName:SDLRPCParameterNameType];
}

- (SDLWindowType)type {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameType error:&error];    
}

- (void)setAssociatedServiceType:(nullable NSString *)associatedServiceType {
    [self.parameters sdl_setObject:associatedServiceType forName:SDLRPCParameterNameAssociatedServiceType];
}

- (nullable NSString *)associatedServiceType {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAssociatedServiceType ofClass:NSString.class error:&error];
}

- (void)setDuplicateUpdatesFromWindowID:(nullable NSNumber<SDLUInt> *)duplicateUpdatesFromWindowID {
    [self.parameters sdl_setObject:duplicateUpdatesFromWindowID forName:SDLRPCParameterNameDuplicateUpdatesFromWindowID];
}

- (nullable NSNumber<SDLUInt> *)duplicateUpdatesFromWindowID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDuplicateUpdatesFromWindowID ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
