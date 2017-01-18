//  SDLSoftButton.m
//

#import "SDLSoftButton.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLNames.h"


@implementation SDLSoftButton

- (instancetype)initWithHandler:(SDLRPCNotificationHandler)handler {
    self = [self init];
    if (!self) {
        return nil;
    }

    _handler = handler;

    return self;
}

- (instancetype)initWithType:(SDLSoftButtonType)type text:(NSString *)text image:(SDLImage *)image highlighted:(BOOL)highlighted buttonId:(UInt16)buttonId systemAction:(SDLSystemAction)systemAction handler:(SDLRPCNotificationHandler)handler {
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
    [store sdl_setObject:type forName:SDLNameType];
}

- (SDLSoftButtonType)type {
    return [store sdl_objectForName:SDLNameType];
}

- (void)setText:(NSString *)text {
    [store sdl_setObject:text forName:SDLNameText];
}

- (NSString *)text {
    return [store sdl_objectForName:SDLNameText];
}

- (void)setImage:(SDLImage *)image {
    [store sdl_setObject:image forName:SDLNameImage];
}

- (SDLImage *)image {
    return [store sdl_objectForName:SDLNameImage ofClass:SDLImage.class];
}

- (void)setIsHighlighted:(NSNumber<SDLBool> *)isHighlighted {
    [store sdl_setObject:isHighlighted forName:SDLNameIsHighlighted];
}

- (NSNumber<SDLBool> *)isHighlighted {
    return [store sdl_objectForName:SDLNameIsHighlighted];
}

- (void)setSoftButtonID:(NSNumber<SDLInt> *)softButtonID {
    [store sdl_setObject:softButtonID forName:SDLNameSoftButtonId];
}

- (NSNumber<SDLInt> *)softButtonID {
    return [store sdl_objectForName:SDLNameSoftButtonId];
}

- (void)setSystemAction:(SDLSystemAction)systemAction {
    [store sdl_setObject:systemAction forName:SDLNameSystemAction];
}

- (SDLSystemAction)systemAction {
    return [store sdl_objectForName:SDLNameSystemAction];
}

@end
