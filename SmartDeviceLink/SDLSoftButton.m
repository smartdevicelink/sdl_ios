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
    if (type != nil) {
        [store setObject:type forKey:SDLNameType];
    } else {
        [store removeObjectForKey:SDLNameType];
    }
}

- (SDLSoftButtonType)type {
    NSObject *obj = [store objectForKey:SDLNameType];
    return (SDLSoftButtonType)obj;
}

- (void)setText:(NSString *)text {
    if (text != nil) {
        [store setObject:text forKey:SDLNameText];
    } else {
        [store removeObjectForKey:SDLNameText];
    }
}

- (NSString *)text {
    return [store objectForKey:SDLNameText];
}

- (void)setImage:(SDLImage *)image {
    if (image != nil) {
        [store setObject:image forKey:SDLNameImage];
    } else {
        [store removeObjectForKey:SDLNameImage];
    }
}

- (SDLImage *)image {
    NSObject *obj = [store objectForKey:SDLNameImage];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setIsHighlighted:(NSNumber<SDLBool> *)isHighlighted {
    if (isHighlighted != nil) {
        [store setObject:isHighlighted forKey:SDLNameIsHighlighted];
    } else {
        [store removeObjectForKey:SDLNameIsHighlighted];
    }
}

- (NSNumber<SDLBool> *)isHighlighted {
    return [store objectForKey:SDLNameIsHighlighted];
}

- (void)setSoftButtonID:(NSNumber<SDLInt> *)softButtonID {
    if (softButtonID != nil) {
        [store setObject:softButtonID forKey:SDLNameSoftButtonId];
    } else {
        [store removeObjectForKey:SDLNameSoftButtonId];
    }
}

- (NSNumber<SDLInt> *)softButtonID {
    return [store objectForKey:SDLNameSoftButtonId];
}

- (void)setSystemAction:(SDLSystemAction)systemAction {
    if (systemAction != nil) {
        [store setObject:systemAction forKey:SDLNameSystemAction];
    } else {
        [store removeObjectForKey:SDLNameSystemAction];
    }
}

- (SDLSystemAction)systemAction {
    NSObject *obj = [store objectForKey:SDLNameSystemAction];
    return (SDLSystemAction)obj;
}

@end
