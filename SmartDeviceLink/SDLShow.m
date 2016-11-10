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

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 alignment:(SDLTextAlignment)alignment {
    return [self initWithMainField1:mainField1 mainField2:mainField2 mainField3:nil mainField4:nil alignment:alignment];
}

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 mainField3:(NSString *)mainField3 mainField4:(NSString *)mainField4 alignment:(SDLTextAlignment)alignment {
    return [self initWithMainField1:mainField1 mainField2:mainField2 mainField3:mainField3 mainField4:mainField4 alignment:alignment statusBar:nil mediaClock:nil mediaTrack:nil graphic:nil softButtons:nil customPresets:nil];
}

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 alignment:(SDLTextAlignment)alignment statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack {
    return [self initWithMainField1:mainField1 mainField2:mainField2 mainField3:nil mainField4:nil alignment:alignment statusBar:statusBar mediaClock:mediaClock mediaTrack:mediaTrack graphic:nil softButtons:nil customPresets:nil];
}

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 mainField3:(NSString *)mainField3 mainField4:(NSString *)mainField4 alignment:(SDLTextAlignment)alignment statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack graphic:(SDLImage *)graphic softButtons:(NSArray<SDLSoftButton *> *)softButtons customPresets:(NSArray<NSString *> *)customPresets {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.mainField1 = mainField1;
    self.mainField2 = mainField2;
    self.mainField3 = mainField3;
    self.mainField4 = mainField4;
    self.statusBar = statusBar;
    self.mediaClock = mediaClock;
    self.mediaTrack = mediaTrack;
    self.alignment = alignment;
    self.graphic = graphic;
    self.softButtons = [softButtons mutableCopy];
    self.customPresets = [customPresets mutableCopy];

    return self;
}

- (void)setMainField1:(NSString *)mainField1 {
    [parameters sdl_setObject:mainField1 forName:SDLNameMainField1];
}

- (NSString *)mainField1 {
    return [parameters sdl_objectForName:SDLNameMainField1];
}

- (void)setMainField2:(NSString *)mainField2 {
    [parameters sdl_setObject:mainField2 forName:SDLNameMainField2];
}

- (NSString *)mainField2 {
    return [parameters sdl_objectForName:SDLNameMainField2];
}

- (void)setMainField3:(NSString *)mainField3 {
    [parameters sdl_setObject:mainField3 forName:SDLNameMainField3];
}

- (NSString *)mainField3 {
    return [parameters sdl_objectForName:SDLNameMainField3];
}

- (void)setMainField4:(NSString *)mainField4 {
    [parameters sdl_setObject:mainField4 forName:SDLNameMainField4];
}

- (NSString *)mainField4 {
    return [parameters sdl_objectForName:SDLNameMainField4];
}

- (void)setAlignment:(SDLTextAlignment)alignment {
    [parameters sdl_setObject:alignment forName:SDLNameAlignment];
}

- (SDLTextAlignment)alignment {
    NSObject *obj = [parameters sdl_objectForName:SDLNameAlignment];
    return (SDLTextAlignment)obj;
}

- (void)setStatusBar:(NSString *)statusBar {
    [parameters sdl_setObject:statusBar forName:SDLNameStatusBar];
}

- (NSString *)statusBar {
    return [parameters sdl_objectForName:SDLNameStatusBar];
}

- (void)setMediaClock:(NSString *)mediaClock {
    [parameters sdl_setObject:mediaClock forName:SDLNameMediaClock];
}

- (NSString *)mediaClock {
    return [parameters sdl_objectForName:SDLNameMediaClock];
}

- (void)setMediaTrack:(NSString *)mediaTrack {
    [parameters sdl_setObject:mediaTrack forName:SDLNameMediaTrack];
}

- (NSString *)mediaTrack {
    return [parameters sdl_objectForName:SDLNameMediaTrack];
}

- (void)setGraphic:(SDLImage *)graphic {
    [parameters sdl_setObject:graphic forName:SDLNameGraphic];
}

- (SDLImage *)graphic {
    NSObject *obj = [parameters sdl_objectForName:SDLNameGraphic];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSecondaryGraphic:(SDLImage *)secondaryGraphic {
    [parameters sdl_setObject:secondaryGraphic forName:SDLNameSecondaryGraphic];
}

- (SDLImage *)secondaryGraphic {
    NSObject *obj = [parameters sdl_objectForName:SDLNameSecondaryGraphic];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    [parameters sdl_setObject:softButtons forName:SDLNameSoftButtons];
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    NSMutableArray<SDLSoftButton *> *array = [parameters sdl_objectForName:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButton *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setCustomPresets:(NSMutableArray<NSString *> *)customPresets {
    [parameters sdl_setObject:customPresets forName:SDLNameCustomPresets];
}

- (NSMutableArray<NSString *> *)customPresets {
    return [parameters sdl_objectForName:SDLNameCustomPresets];
}

@end
