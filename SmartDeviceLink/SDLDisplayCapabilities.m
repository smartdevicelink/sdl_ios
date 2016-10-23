//  SDLDisplayCapabilities.m
//

#import "SDLDisplayCapabilities.h"

#import "SDLNames.h"
#import "SDLImageField.h"
#import "SDLScreenParams.h"
#import "SDLTextField.h"

@implementation SDLDisplayCapabilities

- (void)setDisplayType:(SDLDisplayType)displayType {
    if (displayType != nil) {
        [store setObject:displayType forKey:SDLNameDisplayType];
    } else {
        [store removeObjectForKey:SDLNameDisplayType];
    }
}

- (SDLDisplayType)displayType {
    NSObject *obj = [store objectForKey:SDLNameDisplayType];
    return (SDLDisplayType)obj;
}

- (void)setTextFields:(NSMutableArray<SDLTextField *> *)textFields {
    if (textFields != nil) {
        [store setObject:textFields forKey:SDLNameTextFields];
    } else {
        [store removeObjectForKey:SDLNameTextFields];
    }
}

- (NSMutableArray<SDLTextField *> *)textFields {
    NSMutableArray<SDLTextField *> *array = [store objectForKey:SDLNameTextFields];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTextField.class]) {
        return array;
    } else {
        NSMutableArray<SDLTextField *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTextField alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setImageFields:(NSMutableArray<SDLImageField *> *)imageFields {
    if (imageFields != nil) {
        [store setObject:imageFields forKey:SDLNameImageFields];
    } else {
        [store removeObjectForKey:SDLNameImageFields];
    }
}

- (NSMutableArray<SDLImageField *> *)imageFields {
    NSMutableArray<SDLImageField *> *array = [store objectForKey:SDLNameImageFields];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLImageField.class]) {
        return array;
    } else {
        NSMutableArray<SDLImageField *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLImageField alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setMediaClockFormats:(NSMutableArray<SDLMediaClockFormat> *)mediaClockFormats {
    if (mediaClockFormats != nil) {
        [store setObject:mediaClockFormats forKey:SDLNameMediaClockFormats];
    } else {
        [store removeObjectForKey:SDLNameMediaClockFormats];
    }
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
    if (graphicSupported != nil) {
        [store setObject:graphicSupported forKey:SDLNameGraphicSupported];
    } else {
        [store removeObjectForKey:SDLNameGraphicSupported];
    }
}

- (NSNumber<SDLBool> *)graphicSupported {
    return [store objectForKey:SDLNameGraphicSupported];
}

- (void)setTemplatesAvailable:(NSMutableArray<NSString *> *)templatesAvailable {
    if (templatesAvailable != nil) {
        [store setObject:templatesAvailable forKey:SDLNameTemplatesAvailable];
    } else {
        [store removeObjectForKey:SDLNameTemplatesAvailable];
    }
}

- (NSMutableArray<NSString *> *)templatesAvailable {
    return [store objectForKey:SDLNameTemplatesAvailable];
}

- (void)setScreenParams:(SDLScreenParams *)screenParams {
    if (screenParams != nil) {
        [store setObject:screenParams forKey:SDLNameScreenParams];
    } else {
        [store removeObjectForKey:SDLNameScreenParams];
    }
}

- (SDLScreenParams *)screenParams {
    NSObject *obj = [store objectForKey:SDLNameScreenParams];
    if (obj == nil || [obj isKindOfClass:SDLScreenParams.class]) {
        return (SDLScreenParams *)obj;
    } else {
        return [[SDLScreenParams alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setNumCustomPresetsAvailable:(NSNumber<SDLInt> *)numCustomPresetsAvailable {
    if (numCustomPresetsAvailable != nil) {
        [store setObject:numCustomPresetsAvailable forKey:SDLNameNumberCustomPresetsAvailable];
    } else {
        [store removeObjectForKey:SDLNameNumberCustomPresetsAvailable];
    }
}

- (NSNumber<SDLInt> *)numCustomPresetsAvailable {
    return [store objectForKey:SDLNameNumberCustomPresetsAvailable];
}

@end
