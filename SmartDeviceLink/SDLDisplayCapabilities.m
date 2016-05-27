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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setDisplayType:(SDLDisplayType *)displayType {
    if (displayType != nil) {
        [store setObject:displayType forKey:NAMES_displayType];
    } else {
        [store removeObjectForKey:NAMES_displayType];
    }
}

- (SDLDisplayType *)displayType {
    NSObject *obj = [store objectForKey:NAMES_displayType];
    if (obj == nil || [obj isKindOfClass:SDLDisplayType.class]) {
        return (SDLDisplayType *)obj;
    } else {
        return [SDLDisplayType valueOf:(NSString *)obj];
    }
}

- (void)setTextFields:(NSMutableArray *)textFields {
    if (textFields != nil) {
        [store setObject:textFields forKey:NAMES_textFields];
    } else {
        [store removeObjectForKey:NAMES_textFields];
    }
}

- (NSMutableArray *)textFields {
    NSMutableArray *array = [store objectForKey:NAMES_textFields];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTextField.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTextField alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setImageFields:(NSMutableArray *)imageFields {
    if (imageFields != nil) {
        [store setObject:imageFields forKey:NAMES_imageFields];
    } else {
        [store removeObjectForKey:NAMES_imageFields];
    }
}

- (NSMutableArray *)imageFields {
    NSMutableArray *array = [store objectForKey:NAMES_imageFields];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLImageField.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLImageField alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setMediaClockFormats:(NSMutableArray *)mediaClockFormats {
    if (mediaClockFormats != nil) {
        [store setObject:mediaClockFormats forKey:NAMES_mediaClockFormats];
    } else {
        [store removeObjectForKey:NAMES_mediaClockFormats];
    }
}

- (NSMutableArray *)mediaClockFormats {
    NSMutableArray *array = [store objectForKey:NAMES_mediaClockFormats];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLMediaClockFormat.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLMediaClockFormat valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setGraphicSupported:(NSNumber *)graphicSupported {
    if (graphicSupported != nil) {
        [store setObject:graphicSupported forKey:NAMES_graphicSupported];
    } else {
        [store removeObjectForKey:NAMES_graphicSupported];
    }
}

- (NSNumber *)graphicSupported {
    return [store objectForKey:NAMES_graphicSupported];
}

- (void)setTemplatesAvailable:(NSMutableArray *)templatesAvailable {
    if (templatesAvailable != nil) {
        [store setObject:templatesAvailable forKey:NAMES_templatesAvailable];
    } else {
        [store removeObjectForKey:NAMES_templatesAvailable];
    }
}

- (NSMutableArray *)templatesAvailable {
    return [store objectForKey:NAMES_templatesAvailable];
}

- (void)setScreenParams:(SDLScreenParams *)screenParams {
    if (screenParams != nil) {
        [store setObject:screenParams forKey:NAMES_screenParams];
    } else {
        [store removeObjectForKey:NAMES_screenParams];
    }
}

- (SDLScreenParams *)screenParams {
    NSObject *obj = [store objectForKey:NAMES_screenParams];
    if (obj == nil || [obj isKindOfClass:SDLScreenParams.class]) {
        return (SDLScreenParams *)obj;
    } else {
        return [[SDLScreenParams alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setNumCustomPresetsAvailable:(NSNumber *)numCustomPresetsAvailable {
    if (numCustomPresetsAvailable != nil) {
        [store setObject:numCustomPresetsAvailable forKey:NAMES_numCustomPresetsAvailable];
    } else {
        [store removeObjectForKey:NAMES_numCustomPresetsAvailable];
    }
}

- (NSNumber *)numCustomPresetsAvailable {
    return [store objectForKey:NAMES_numCustomPresetsAvailable];
}

@end
