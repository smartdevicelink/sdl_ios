//  SDLDisplayCapabilities.m
//

#import "SDLDisplayCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLImageField.h"
#import "SDLScreenParams.h"
#import "SDLTextField.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDisplayCapabilities

- (void)setDisplayType:(SDLDisplayType)displayType {
    [store sdl_setObject:displayType forName:SDLNameDisplayType];
}

- (SDLDisplayType)displayType {
    return [store sdl_objectForName:SDLNameDisplayType];
}

- (void)setTextFields:(NSArray<SDLTextField *> *)textFields {
    [store sdl_setObject:textFields forName:SDLNameTextFields];
}

- (NSArray<SDLTextField *> *)textFields {
    return [store sdl_objectsForName:SDLNameTextFields ofClass:SDLTextField.class];
}

- (void)setImageFields:(nullable NSArray<SDLImageField *> *)imageFields {
    [store sdl_setObject:imageFields forName:SDLNameImageFields];
}

- (nullable NSArray<SDLImageField *> *)imageFields {
    return [store sdl_objectsForName:SDLNameImageFields ofClass:SDLImageField.class];
}

- (void)setMediaClockFormats:(NSArray<SDLMediaClockFormat> *)mediaClockFormats {
    [store sdl_setObject:mediaClockFormats forName:SDLNameMediaClockFormats];
}

- (NSArray<SDLMediaClockFormat> *)mediaClockFormats {
    return [store sdl_objectForName:SDLNameMediaClockFormats];
}

- (void)setGraphicSupported:(NSNumber<SDLBool> *)graphicSupported {
    [store sdl_setObject:graphicSupported forName:SDLNameGraphicSupported];
}

- (NSNumber<SDLBool> *)graphicSupported {
    return [store sdl_objectForName:SDLNameGraphicSupported];
}

- (void)setTemplatesAvailable:(nullable NSArray<NSString *> *)templatesAvailable {
    [store sdl_setObject:templatesAvailable forName:SDLNameTemplatesAvailable];
}

- (nullable NSArray<NSString *> *)templatesAvailable {
    return [store sdl_objectForName:SDLNameTemplatesAvailable];
}

- (void)setScreenParams:(nullable SDLScreenParams *)screenParams {
    [store sdl_setObject:screenParams forName:SDLNameScreenParams];
}

- (nullable SDLScreenParams *)screenParams {
    return [store sdl_objectForName:SDLNameScreenParams ofClass:SDLScreenParams.class];
}

- (void)setNumCustomPresetsAvailable:(nullable NSNumber<SDLInt> *)numCustomPresetsAvailable {
    [store sdl_setObject:numCustomPresetsAvailable forName:SDLNameNumberCustomPresetsAvailable];
}

- (nullable NSNumber<SDLInt> *)numCustomPresetsAvailable {
    return [store sdl_objectForName:SDLNameNumberCustomPresetsAvailable];
}

@end

NS_ASSUME_NONNULL_END
