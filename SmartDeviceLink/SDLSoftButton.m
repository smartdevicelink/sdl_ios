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
    [store sdl_setObject:type forName:SDLRPCParameterNameType];
}

- (SDLSoftButtonType)type {
    return [store sdl_objectForName:SDLRPCParameterNameType];
}

- (void)setText:(nullable NSString *)text {
    [store sdl_setObject:text forName:SDLRPCParameterNameText];
}

- (nullable NSString *)text {
    return [store sdl_objectForName:SDLRPCParameterNameText];
}

- (void)setImage:(nullable SDLImage *)image {
    [store sdl_setObject:image forName:SDLRPCParameterNameImage];
}

- (nullable SDLImage *)image {
    return [store sdl_objectForName:SDLRPCParameterNameImage ofClass:SDLImage.class];
}

- (void)setIsHighlighted:(nullable NSNumber<SDLBool> *)isHighlighted {
    [store sdl_setObject:isHighlighted forName:SDLRPCParameterNameIsHighlighted];
}

- (nullable NSNumber<SDLBool> *)isHighlighted {
    return [store sdl_objectForName:SDLRPCParameterNameIsHighlighted];
}

- (void)setSoftButtonID:(NSNumber<SDLInt> *)softButtonID {
    [store sdl_setObject:softButtonID forName:SDLRPCParameterNameSoftButtonId];
}

- (NSNumber<SDLInt> *)softButtonID {
    return [store sdl_objectForName:SDLRPCParameterNameSoftButtonId];
}

- (void)setSystemAction:(nullable SDLSystemAction)systemAction {
    [store sdl_setObject:systemAction forName:SDLRPCParameterNameSystemAction];
}

- (nullable SDLSystemAction)systemAction {
    return [store sdl_objectForName:SDLRPCParameterNameSystemAction];
}

-(id)copyWithZone:(nullable NSZone *)zone {
    SDLSoftButton *newButton = [super copyWithZone:zone];
    newButton->_handler = self.handler;

    return newButton;
}

@end

NS_ASSUME_NONNULL_END
