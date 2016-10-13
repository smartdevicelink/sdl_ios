//  SDLShow.m
//


#import "SDLShow.h"

#import "SDLImage.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"


@implementation SDLShow

- (instancetype)init {
    if (self = [super initWithName:SDLNameShow]) {
    }
    return self;
}

- (void)setMainField1:(NSString *)mainField1 {
    if (mainField1 != nil) {
        [parameters setObject:mainField1 forKey:SDLNameMainField1];
    } else {
        [parameters removeObjectForKey:SDLNameMainField1];
    }
}

- (NSString *)mainField1 {
    return [parameters objectForKey:SDLNameMainField1];
}

- (void)setMainField2:(NSString *)mainField2 {
    if (mainField2 != nil) {
        [parameters setObject:mainField2 forKey:SDLNameMainField2];
    } else {
        [parameters removeObjectForKey:SDLNameMainField2];
    }
}

- (NSString *)mainField2 {
    return [parameters objectForKey:SDLNameMainField2];
}

- (void)setMainField3:(NSString *)mainField3 {
    if (mainField3 != nil) {
        [parameters setObject:mainField3 forKey:SDLNameMainField3];
    } else {
        [parameters removeObjectForKey:SDLNameMainField3];
    }
}

- (NSString *)mainField3 {
    return [parameters objectForKey:SDLNameMainField3];
}

- (void)setMainField4:(NSString *)mainField4 {
    if (mainField4 != nil) {
        [parameters setObject:mainField4 forKey:SDLNameMainField4];
    } else {
        [parameters removeObjectForKey:SDLNameMainField4];
    }
}

- (NSString *)mainField4 {
    return [parameters objectForKey:SDLNameMainField4];
}

- (void)setAlignment:(SDLTextAlignment)alignment {
    if (alignment != nil) {
        [parameters setObject:alignment forKey:SDLNameAlignment];
    } else {
        [parameters removeObjectForKey:SDLNameAlignment];
    }
}

- (SDLTextAlignment)alignment {
    NSObject *obj = [parameters objectForKey:SDLNameAlignment];
    return (SDLTextAlignment)obj;
}

- (void)setStatusBar:(NSString *)statusBar {
    if (statusBar != nil) {
        [parameters setObject:statusBar forKey:SDLNameStatusBar];
    } else {
        [parameters removeObjectForKey:SDLNameStatusBar];
    }
}

- (NSString *)statusBar {
    return [parameters objectForKey:SDLNameStatusBar];
}

- (void)setMediaClock:(NSString *)mediaClock {
    if (mediaClock != nil) {
        [parameters setObject:mediaClock forKey:SDLNameMediaClock];
    } else {
        [parameters removeObjectForKey:SDLNameMediaClock];
    }
}

- (NSString *)mediaClock {
    return [parameters objectForKey:SDLNameMediaClock];
}

- (void)setMediaTrack:(NSString *)mediaTrack {
    if (mediaTrack != nil) {
        [parameters setObject:mediaTrack forKey:SDLNameMediaTrack];
    } else {
        [parameters removeObjectForKey:SDLNameMediaTrack];
    }
}

- (NSString *)mediaTrack {
    return [parameters objectForKey:SDLNameMediaTrack];
}

- (void)setGraphic:(SDLImage *)graphic {
    if (graphic != nil) {
        [parameters setObject:graphic forKey:SDLNameGraphic];
    } else {
        [parameters removeObjectForKey:SDLNameGraphic];
    }
}

- (SDLImage *)graphic {
    NSObject *obj = [parameters objectForKey:SDLNameGraphic];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSecondaryGraphic:(SDLImage *)secondaryGraphic {
    if (secondaryGraphic != nil) {
        [parameters setObject:secondaryGraphic forKey:SDLNameSecondaryGraphic];
    } else {
        [parameters removeObjectForKey:SDLNameSecondaryGraphic];
    }
}

- (SDLImage *)secondaryGraphic {
    NSObject *obj = [parameters objectForKey:SDLNameSecondaryGraphic];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (NSMutableArray *)softButtons {
    NSMutableArray *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setCustomPresets:(NSMutableArray *)customPresets {
    if (customPresets != nil) {
        [parameters setObject:customPresets forKey:SDLNameCustomPresets];
    } else {
        [parameters removeObjectForKey:SDLNameCustomPresets];
    }
}

- (NSMutableArray *)customPresets {
    return [parameters objectForKey:SDLNameCustomPresets];
}

@end
