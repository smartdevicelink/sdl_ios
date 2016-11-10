//  SDLDisplayCapabilities.m
//

#import "SDLDisplayCapabilities.h"

#import "SDLNames.h"
#import "SDLImageField.h"
#import "SDLScreenParams.h"
#import "SDLTextField.h"

@implementation SDLDisplayCapabilities

- (void)setDisplayType:(SDLDisplayType)displayType {
    [store sdl_setObject:displayType forName:SDLNameDisplayType];
}

- (SDLDisplayType)displayType {
    return [store sdl_objectForName:SDLNameDisplayType];
}

- (void)setTextFields:(NSMutableArray<SDLTextField *> *)textFields {
    [store sdl_setObject:textFields forName:SDLNameTextFields];
}

- (NSMutableArray<SDLTextField *> *)textFields {
    return [store sdl_objectsForName:SDLNameTextFields ofClass:SDLTextField.class];
}

- (void)setImageFields:(NSMutableArray<SDLImageField *> *)imageFields {
    [store sdl_setObject:imageFields forName:SDLNameImageFields];
}

- (NSMutableArray<SDLImageField *> *)imageFields {
    return [store sdl_objectsForName:SDLNameImageFields ofClass:SDLImageField.class];
}

- (void)setMediaClockFormats:(NSMutableArray<SDLMediaClockFormat> *)mediaClockFormats {
    [store sdl_setObject:mediaClockFormats forName:SDLNameMediaClockFormats];
}

- (NSMutableArray<SDLMediaClockFormat> *)mediaClockFormats {
    NSMutableArray<SDLMediaClockFormat> *array = [store objectForKey:SDLNameMediaClockFormats];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLMediaClockFormat> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLMediaClockFormat)enumString];
        }
        return newList;
    }
}

- (void)setGraphicSupported:(NSNumber<SDLBool> *)graphicSupported {
    [store sdl_setObject:graphicSupported forName:SDLNameGraphicSupported];
}

- (NSNumber<SDLBool> *)graphicSupported {
    return [store sdl_objectForName:SDLNameGraphicSupported];
}

- (void)setTemplatesAvailable:(NSMutableArray<NSString *> *)templatesAvailable {
    [store sdl_setObject:templatesAvailable forName:SDLNameTemplatesAvailable];
}

- (NSMutableArray<NSString *> *)templatesAvailable {
    return [store sdl_objectForName:SDLNameTemplatesAvailable];
}

- (void)setScreenParams:(SDLScreenParams *)screenParams {
    [store sdl_setObject:screenParams forName:SDLNameScreenParams];
}

- (SDLScreenParams *)screenParams {
    return [store sdl_objectForName:SDLNameScreenParams ofClass:SDLScreenParams.class];
}

- (void)setNumCustomPresetsAvailable:(NSNumber<SDLInt> *)numCustomPresetsAvailable {
    [store sdl_setObject:numCustomPresetsAvailable forName:SDLNameNumberCustomPresetsAvailable];
}

- (NSNumber<SDLInt> *)numCustomPresetsAvailable {
    return [store sdl_objectForName:SDLNameNumberCustomPresetsAvailable];
}

@end
