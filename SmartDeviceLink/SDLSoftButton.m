//  SDLSoftButton.m
//

#import "SDLSoftButton.h"

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
    [self setObject:type forName:SDLNameType];
}

- (SDLSoftButtonType)type {
    return [self objectForName:SDLNameType];
}

- (void)setText:(NSString *)text {
    [self setObject:text forName:SDLNameText];
}

- (NSString *)text {
    return [self objectForName:SDLNameText];
}

- (void)setImage:(SDLImage *)image {
    [self setObject:image forName:SDLNameImage];
}

- (SDLImage *)image {
    return [self objectForName:SDLNameImage ofClass:SDLImage.class];
}

- (void)setIsHighlighted:(NSNumber<SDLBool> *)isHighlighted {
    [self setObject:isHighlighted forName:SDLNameIsHighlighted];
}

- (NSNumber<SDLBool> *)isHighlighted {
    return [self objectForName:SDLNameIsHighlighted];
}

- (void)setSoftButtonID:(NSNumber<SDLInt> *)softButtonID {
    [self setObject:softButtonID forName:SDLNameSoftButtonId];
}

- (NSNumber<SDLInt> *)softButtonID {
    return [self objectForName:SDLNameSoftButtonId];
}

- (void)setSystemAction:(SDLSystemAction)systemAction {
    [self setObject:systemAction forName:SDLNameSystemAction];
}

- (SDLSystemAction)systemAction {
    return [self objectForName:SDLNameSystemAction];
}

@end
