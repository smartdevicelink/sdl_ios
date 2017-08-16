//  SDLShow.m
//


#import "SDLShow.h"

#import "SDLImage.h"
#import "SDLMetadataTags.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTextAlignment.h"


@implementation SDLShow

- (instancetype)init {
    if (self = [super initWithName:NAMES_Show]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 alignment:(SDLTextAlignment *)alignment {
    return [self initWithMainField1:mainField1 mainField2:mainField2 mainField3:nil mainField4:nil alignment:alignment];
}

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField1Type:(SDLMetadataType *)mainField1Type mainField2:(NSString *)mainField2 mainField2Type:(SDLMetadataType *)mainField2Type alignment:(SDLTextAlignment *)alignment {
    self = [self init];
    if (!self) {
        return nil;
    }

    NSArray<SDLMetadataType *> *field1Array = @[mainField1Type];
    NSArray<SDLMetadataType *> *field2Array = @[mainField2Type];
    SDLMetadataTags* fieldsStruct = [[SDLMetadataTags alloc] initWithTextFieldTypes:field1Array mainField2:field2Array];

    self.mainField1 = mainField1;
    self.mainField2 = mainField2;
    self.alignment = alignment;
    self.metadataTags = fieldsStruct;

    return self;
}

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 alignment:(SDLTextAlignment *)alignment statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack {
    return [self initWithMainField1:mainField1 mainField2:mainField2 mainField3:nil mainField4:nil alignment:alignment statusBar:statusBar mediaClock:mediaClock mediaTrack:mediaTrack graphic:nil softButtons:nil customPresets:nil textFieldMetadata:nil];
}

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 mainField3:(NSString *)mainField3 mainField4:(NSString *)mainField4 alignment:(SDLTextAlignment *)alignment {
    return [self initWithMainField1:mainField1 mainField2:mainField2 mainField3:mainField3 mainField4:mainField4 alignment:alignment statusBar:nil mediaClock:nil mediaTrack:nil graphic:nil softButtons:nil customPresets:nil textFieldMetadata:nil];
}

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField1Type:(SDLMetadataType *)mainField1Type mainField2:(NSString *)mainField2 mainField2Type:(SDLMetadataType *)mainField2Type mainField3:(NSString *)mainField3 mainField3Type:(SDLMetadataType *)mainField3Type mainField4:(NSString *)mainField4 mainField4Type:(SDLMetadataType *)mainField4Type alignment:(SDLTextAlignment *)alignment{
    self = [self init];
    if (!self) {
        return nil;
    }

    NSArray<SDLMetadataType *> *field1Array = @[mainField1Type];
    NSArray<SDLMetadataType *> *field2Array = @[mainField2Type];
    NSArray<SDLMetadataType *> *field3Array = @[mainField3Type];
    NSArray<SDLMetadataType *> *field4Array = @[mainField4Type];
    SDLMetadataTags* fieldsStruct = [[SDLMetadataTags alloc] initWithTextFieldTypes:field1Array mainField2:field2Array mainField3:field3Array mainField4:field4Array];

    self.mainField1 = mainField1;
    self.mainField2 = mainField2;
    self.mainField3 = mainField3;
    self.mainField4 = mainField4;
    self.alignment = alignment;
    self.metadataTags = fieldsStruct;

    return self;
}

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 mainField3:(NSString *)mainField3 mainField4:(NSString *)mainField4 alignment:(SDLTextAlignment *)alignment statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack graphic:(SDLImage *)graphic softButtons:(NSArray<SDLSoftButton *> *)softButtons customPresets:(NSArray<NSString *> *)customPresets {
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

- (instancetype)initWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 mainField3:(NSString *)mainField3 mainField4:(NSString *)mainField4 alignment:(SDLTextAlignment *)alignment statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack graphic:(SDLImage *)graphic softButtons:(NSArray<SDLSoftButton *> *)softButtons customPresets:(NSArray<NSString *> *)customPresets textFieldMetadata:(SDLMetadataTags *)metadata {
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
    self.metadataTags = metadata;

    return self;

}

- (void)setMainField1:(NSString *)mainField1 {
    if (mainField1 != nil) {
        [parameters setObject:mainField1 forKey:NAMES_mainField1];
    } else {
        [parameters removeObjectForKey:NAMES_mainField1];
    }
}

- (NSString *)mainField1 {
    return [parameters objectForKey:NAMES_mainField1];
}

- (void)setMainField2:(NSString *)mainField2 {
    if (mainField2 != nil) {
        [parameters setObject:mainField2 forKey:NAMES_mainField2];
    } else {
        [parameters removeObjectForKey:NAMES_mainField2];
    }
}

- (NSString *)mainField2 {
    return [parameters objectForKey:NAMES_mainField2];
}

- (void)setMainField3:(NSString *)mainField3 {
    if (mainField3 != nil) {
        [parameters setObject:mainField3 forKey:NAMES_mainField3];
    } else {
        [parameters removeObjectForKey:NAMES_mainField3];
    }
}

- (NSString *)mainField3 {
    return [parameters objectForKey:NAMES_mainField3];
}

- (void)setMainField4:(NSString *)mainField4 {
    if (mainField4 != nil) {
        [parameters setObject:mainField4 forKey:NAMES_mainField4];
    } else {
        [parameters removeObjectForKey:NAMES_mainField4];
    }
}

- (NSString *)mainField4 {
    return [parameters objectForKey:NAMES_mainField4];
}

- (void)setAlignment:(SDLTextAlignment *)alignment {
    if (alignment != nil) {
        [parameters setObject:alignment forKey:NAMES_alignment];
    } else {
        [parameters removeObjectForKey:NAMES_alignment];
    }
}

- (SDLTextAlignment *)alignment {
    NSObject *obj = [parameters objectForKey:NAMES_alignment];
    if (obj == nil || [obj isKindOfClass:SDLTextAlignment.class]) {
        return (SDLTextAlignment *)obj;
    } else {
        return [SDLTextAlignment valueOf:(NSString *)obj];
    }
}

- (void)setStatusBar:(NSString *)statusBar {
    if (statusBar != nil) {
        [parameters setObject:statusBar forKey:NAMES_statusBar];
    } else {
        [parameters removeObjectForKey:NAMES_statusBar];
    }
}

- (NSString *)statusBar {
    return [parameters objectForKey:NAMES_statusBar];
}

- (void)setMediaClock:(NSString *)mediaClock {
    if (mediaClock != nil) {
        [parameters setObject:mediaClock forKey:NAMES_mediaClock];
    } else {
        [parameters removeObjectForKey:NAMES_mediaClock];
    }
}

- (NSString *)mediaClock {
    return [parameters objectForKey:NAMES_mediaClock];
}

- (void)setMediaTrack:(NSString *)mediaTrack {
    if (mediaTrack != nil) {
        [parameters setObject:mediaTrack forKey:NAMES_mediaTrack];
    } else {
        [parameters removeObjectForKey:NAMES_mediaTrack];
    }
}

- (NSString *)mediaTrack {
    return [parameters objectForKey:NAMES_mediaTrack];
}

- (void)setGraphic:(SDLImage *)graphic {
    if (graphic != nil) {
        [parameters setObject:graphic forKey:NAMES_graphic];
    } else {
        [parameters removeObjectForKey:NAMES_graphic];
    }
}

- (SDLImage *)graphic {
    NSObject *obj = [parameters objectForKey:NAMES_graphic];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setSecondaryGraphic:(SDLImage *)secondaryGraphic {
    if (secondaryGraphic != nil) {
        [parameters setObject:secondaryGraphic forKey:NAMES_secondaryGraphic];
    } else {
        [parameters removeObjectForKey:NAMES_secondaryGraphic];
    }
}

- (SDLImage *)secondaryGraphic {
    NSObject *obj = [parameters objectForKey:NAMES_secondaryGraphic];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:NAMES_softButtons];
    } else {
        [parameters removeObjectForKey:NAMES_softButtons];
    }
}

- (NSMutableArray *)softButtons {
    NSMutableArray *array = [parameters objectForKey:NAMES_softButtons];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setCustomPresets:(NSMutableArray *)customPresets {
    if (customPresets != nil) {
        [parameters setObject:customPresets forKey:NAMES_customPresets];
    } else {
        [parameters removeObjectForKey:NAMES_customPresets];
    }
}

- (NSMutableArray *)customPresets {
    return [parameters objectForKey:NAMES_customPresets];
}

- (void)setMetadataTags:(SDLMetadataTags *)metadataTags {
    if (metadataTags != nil) {
        [parameters setObject:metadataTags forKey:NAMES_metadataTags];
    } else {
        [parameters removeObjectForKey:NAMES_metadataTags];
    }
}

- (SDLMetadataTags *)metadataTags {
    NSObject *obj = [parameters objectForKey:NAMES_metadataTags];
    if (obj == nil || [obj isKindOfClass:SDLMetadataTags.class]) {
        return (SDLMetadataTags *)obj;
    } else {
        return [[SDLMetadataTags alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
