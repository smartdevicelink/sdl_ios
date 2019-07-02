//  SDLSoftButton.m
//

#import "SDLSoftButton.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSoftButton

- (instancetype)initWithHandler:(nullable SDLRPCButtonNotificationHandler)handler {
    self = [self init];
    if (!self) {
        return nil;
    }

    _handler = handler;

    return self;
}

- (instancetype)initWithType:(SDLSoftButtonType)type text:(nullable NSString *)text image:(nullable SDLImage *)image highlighted:(BOOL)highlighted buttonId:(UInt16)buttonId systemAction:(nullable SDLSystemAction)systemAction handler:(nullable SDLRPCButtonNotificationHandler)handler {
    self = [self initWithHandler:handler];
    if (!self) {
        return nil;
    }

    self.type = type;
    self.text = text;
    self.image = image;
    self.isHighlighted = @(highlighted);
    self.softButtonID = @(buttonId);
    self.systemAction = systemAction;
    self.handler = handler;

    return self;
}

- (void)setType:(SDLSoftButtonType)type {
    [self.store sdl_setObject:type forName:SDLRPCParameterNameType];
}

- (SDLSoftButtonType)type {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameType error:&error];
}

- (void)setText:(nullable NSString *)text {
    [self.store sdl_setObject:text forName:SDLRPCParameterNameText];
}

- (nullable NSString *)text {
    return [self.store sdl_objectForName:SDLRPCParameterNameText ofClass:NSString.class error:nil];
}

- (void)setImage:(nullable SDLImage *)image {
    [self.store sdl_setObject:image forName:SDLRPCParameterNameImage];
}

- (nullable SDLImage *)image {
    return [self.store sdl_objectForName:SDLRPCParameterNameImage ofClass:SDLImage.class error:nil];
}

- (void)setIsHighlighted:(nullable NSNumber<SDLBool> *)isHighlighted {
    [self.store sdl_setObject:isHighlighted forName:SDLRPCParameterNameIsHighlighted];
}

- (nullable NSNumber<SDLBool> *)isHighlighted {
    return [self.store sdl_objectForName:SDLRPCParameterNameIsHighlighted ofClass:NSNumber.class error:nil];
}

- (void)setSoftButtonID:(NSNumber<SDLInt> *)softButtonID {
    [self.store sdl_setObject:softButtonID forName:SDLRPCParameterNameSoftButtonId];
}

- (NSNumber<SDLInt> *)softButtonID {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameSoftButtonId ofClass:NSNumber.class error:&error];
}

- (void)setSystemAction:(nullable SDLSystemAction)systemAction {
    [self.store sdl_setObject:systemAction forName:SDLRPCParameterNameSystemAction];
}

- (nullable SDLSystemAction)systemAction {
    return [self.store sdl_enumForName:SDLRPCParameterNameSystemAction error:nil];
}

-(id)copyWithZone:(nullable NSZone *)zone {
    SDLSoftButton *newButton = [super copyWithZone:zone];
    newButton->_handler = self.handler;

    return newButton;
}

@end

NS_ASSUME_NONNULL_END
