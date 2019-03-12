//  SDLDisplayCapabilities.m
//

#import "SDLDisplayCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLImageField.h"
#import "SDLScreenParams.h"
#import "SDLTextField.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDisplayCapabilities

- (void)setDisplayType:(SDLDisplayType)displayType {
    [store sdl_setObject:displayType forName:SDLRPCParameterNameDisplayType];
}

- (SDLDisplayType)displayType {
    return [store sdl_objectForName:SDLRPCParameterNameDisplayType];
}

- (void)setDisplayName:(nullable NSString *)displayName {
    [store sdl_setObject:displayName forName:SDLRPCParameterNameDisplayName];
}

- (nullable NSString *)displayName {
    return [store sdl_objectForName:SDLRPCParameterNameDisplayName];
}

- (void)setTextFields:(NSArray<SDLTextField *> *)textFields {
    [store sdl_setObject:textFields forName:SDLRPCParameterNameTextFields];
}

- (NSArray<SDLTextField *> *)textFields {
    return [store sdl_objectsForName:SDLRPCParameterNameTextFields ofClass:SDLTextField.class];
}

- (void)setImageFields:(nullable NSArray<SDLImageField *> *)imageFields {
    [store sdl_setObject:imageFields forName:SDLRPCParameterNameImageFields];
}

- (nullable NSArray<SDLImageField *> *)imageFields {
    return [store sdl_objectsForName:SDLRPCParameterNameImageFields ofClass:SDLImageField.class];
}

- (void)setMediaClockFormats:(NSArray<SDLMediaClockFormat> *)mediaClockFormats {
    [store sdl_setObject:mediaClockFormats forName:SDLRPCParameterNameMediaClockFormats];
}

- (NSArray<SDLMediaClockFormat> *)mediaClockFormats {
    return [store sdl_objectForName:SDLRPCParameterNameMediaClockFormats];
}

- (void)setGraphicSupported:(NSNumber<SDLBool> *)graphicSupported {
    [store sdl_setObject:graphicSupported forName:SDLRPCParameterNameGraphicSupported];
}

- (NSNumber<SDLBool> *)graphicSupported {
    return [store sdl_objectForName:SDLRPCParameterNameGraphicSupported];
}

- (void)setTemplatesAvailable:(nullable NSArray<NSString *> *)templatesAvailable {
    [store sdl_setObject:templatesAvailable forName:SDLRPCParameterNameTemplatesAvailable];
}

- (nullable NSArray<NSString *> *)templatesAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameTemplatesAvailable];
}

- (void)setScreenParams:(nullable SDLScreenParams *)screenParams {
    [store sdl_setObject:screenParams forName:SDLRPCParameterNameScreenParams];
}

- (nullable SDLScreenParams *)screenParams {
    return [store sdl_objectForName:SDLRPCParameterNameScreenParams ofClass:SDLScreenParams.class];
}

- (void)setNumCustomPresetsAvailable:(nullable NSNumber<SDLInt> *)numCustomPresetsAvailable {
    [store sdl_setObject:numCustomPresetsAvailable forName:SDLRPCParameterNameNumberCustomPresetsAvailable];
}

- (nullable NSNumber<SDLInt> *)numCustomPresetsAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameNumberCustomPresetsAvailable];
}

@end

NS_ASSUME_NONNULL_END
