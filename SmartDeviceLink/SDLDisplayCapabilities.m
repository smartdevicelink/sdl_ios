//  SDLDisplayCapabilities.m
//

#import "SDLDisplayCapabilities.h"

#import "SDLNames.h"
#import "SDLImageField.h"
#import "SDLScreenParams.h"
#import "SDLTextField.h"

@implementation SDLDisplayCapabilities

- (void)setDisplayType:(SDLDisplayType)displayType {
    [self setObject:displayType forName:SDLNameDisplayType];
}

- (SDLDisplayType)displayType {
    return [self objectForName:SDLNameDisplayType];
}

- (void)setTextFields:(NSMutableArray<SDLTextField *> *)textFields {
    [self setObject:textFields forName:SDLNameTextFields];
}

- (NSMutableArray<SDLTextField *> *)textFields {
    return [self objectsForName:SDLNameTextFields ofClass:SDLTextField.class];
}

- (void)setImageFields:(NSMutableArray<SDLImageField *> *)imageFields {
    [self setObject:imageFields forName:SDLNameImageFields];
}

- (NSMutableArray<SDLImageField *> *)imageFields {
    return [self objectsForName:SDLNameImageFields ofClass:SDLImageField.class];
}

- (void)setMediaClockFormats:(NSMutableArray<SDLMediaClockFormat> *)mediaClockFormats {
    [self setObject:mediaClockFormats forName:SDLNameMediaClockFormats];
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
    [self setObject:graphicSupported forName:SDLNameGraphicSupported];
}

- (NSNumber<SDLBool> *)graphicSupported {
    return [self objectForName:SDLNameGraphicSupported];
}

- (void)setTemplatesAvailable:(NSMutableArray<NSString *> *)templatesAvailable {
    [self setObject:templatesAvailable forName:SDLNameTemplatesAvailable];
}

- (NSMutableArray<NSString *> *)templatesAvailable {
    return [self objectForName:SDLNameTemplatesAvailable];
}

- (void)setScreenParams:(SDLScreenParams *)screenParams {
    [self setObject:screenParams forName:SDLNameScreenParams];
}

- (SDLScreenParams *)screenParams {
    return [self objectForName:SDLNameScreenParams ofClass:SDLScreenParams.class];
}

- (void)setNumCustomPresetsAvailable:(NSNumber<SDLInt> *)numCustomPresetsAvailable {
    [self setObject:numCustomPresetsAvailable forName:SDLNameNumberCustomPresetsAvailable];
}

- (NSNumber<SDLInt> *)numCustomPresetsAvailable {
    return [self objectForName:SDLNameNumberCustomPresetsAvailable];
}

@end
