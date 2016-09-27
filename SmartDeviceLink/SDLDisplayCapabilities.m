//  SDLDisplayCapabilities.m
//

#import "SDLDisplayCapabilities.h"

#import "SDLDisplayType.h"
#import "SDLImageField.h"
#import "SDLMediaClockFormat.h"
#import "SDLNames.h"
#import "SDLScreenParams.h"
#import "SDLTextField.h"

@implementation SDLDisplayCapabilities

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setDisplayType:(SDLDisplayType *)displayType {
    if (displayType != nil) {
        [store setObject:displayType forKey:SDLNameDisplayType];
    } else {
        [store removeObjectForKey:SDLNameDisplayType];
    }
}

- (SDLDisplayType *)displayType {
    NSObject *obj = [store objectForKey:SDLNameDisplayType];
    if (obj == nil || [obj isKindOfClass:SDLDisplayType.class]) {
        return (SDLDisplayType *)obj;
    } else {
        return [SDLDisplayType valueOf:(NSString *)obj];
    }
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
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTextField alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
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
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLImageField alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
        }
        return newList;
    }
}

- (void)setMediaClockFormats:(NSMutableArray<SDLMediaClockFormat *> *)mediaClockFormats {
    if (mediaClockFormats != nil) {
        [store setObject:mediaClockFormats forKey:SDLNameMediaClockFormats];
    } else {
        [store removeObjectForKey:SDLNameMediaClockFormats];
    }
}

- (NSMutableArray<SDLMediaClockFormat *> *)mediaClockFormats {
    NSMutableArray<SDLMediaClockFormat *> *array = [store objectForKey:SDLNameMediaClockFormats];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLMediaClockFormat.class]) {
        return array;
    } else {
        NSMutableArray<SDLMediaClockFormat *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLMediaClockFormat valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setGraphicSupported:(NSNumber *)graphicSupported {
    if (graphicSupported != nil) {
        [store setObject:graphicSupported forKey:SDLNameGraphicSupported];
    } else {
        [store removeObjectForKey:SDLNameGraphicSupported];
    }
}

- (NSNumber *)graphicSupported {
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
        return [[SDLScreenParams alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setNumCustomPresetsAvailable:(NSNumber *)numCustomPresetsAvailable {
    if (numCustomPresetsAvailable != nil) {
        [store setObject:numCustomPresetsAvailable forKey:SDLNameNumberCustomPresetsAvailable];
    } else {
        [store removeObjectForKey:SDLNameNumberCustomPresetsAvailable];
    }
}

- (NSNumber *)numCustomPresetsAvailable {
    return [store objectForKey:SDLNameNumberCustomPresetsAvailable];
}

@end
