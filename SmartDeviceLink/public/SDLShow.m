//  SDLShow.m
//


#import "SDLShow.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLMetadataTags.h"
#import "SDLMetadataType.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSoftButton.h"
#import "SDLTemplateConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLShow

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameShow]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField2:(nullable NSString *)mainField2 alignment:(nullable SDLTextAlignment)alignment {
    return [self initWithMainField1:mainField1 mainField2:mainField2 mainField3:nil mainField4:nil alignment:alignment];
}

- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField1Type:(nullable SDLMetadataType)mainField1Type mainField2:(nullable NSString *)mainField2 mainField2Type:(nullable SDLMetadataType)mainField2Type alignment:(nullable SDLTextAlignment)alignment {
    self = [self init];
    if (!self) {
        return nil;
    }

    NSArray<SDLMetadataType> *field1Array = mainField1Type ? @[mainField1Type] : nil;
    NSArray<SDLMetadataType> *field2Array = mainField2Type ? @[mainField2Type] : nil;
    SDLMetadataTags* metadataTags = (field1Array != nil || field2Array != nil) ? [[SDLMetadataTags alloc] initWithTextFieldTypes:field1Array mainField2:field2Array] : nil;

    self.mainField1 = mainField1;
    self.mainField2 = mainField2;
    self.alignment = alignment;
    self.metadataTags = metadataTags;

    return self;
}

- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField2:(nullable NSString *)mainField2 mainField3:(nullable NSString *)mainField3 mainField4:(nullable NSString *)mainField4 alignment:(nullable SDLTextAlignment)alignment {
    return [self initWithMainField1:mainField1 mainField2:mainField2 mainField3:mainField3 mainField4:mainField4 alignment:alignment statusBar:nil mediaClock:nil mediaTrack:nil graphic:nil softButtons:nil customPresets:nil textFieldMetadata:nil];
}

- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField1Type:(nullable SDLMetadataType)mainField1Type mainField2:(nullable NSString *)mainField2 mainField2Type:(nullable SDLMetadataType)mainField2Type mainField3:(nullable NSString *)mainField3 mainField3Type:(nullable SDLMetadataType)mainField3Type mainField4:(nullable NSString *)mainField4 mainField4Type:(nullable SDLMetadataType)mainField4Type alignment:(nullable SDLTextAlignment)alignment {
    self = [self init];
    if (!self) {
        return nil;
    }

    NSArray<SDLMetadataType> *field1Array = mainField1Type ? @[mainField1Type] : nil;
    NSArray<SDLMetadataType> *field2Array = mainField2Type ? @[mainField2Type] : nil;
    NSArray<SDLMetadataType> *field3Array = mainField3Type ? @[mainField3Type] : nil;
    NSArray<SDLMetadataType> *field4Array = mainField4Type ? @[mainField4Type] : nil;
    SDLMetadataTags* metadataTags = (field1Array != nil || field2Array != nil || field3Array != nil || field4Array != nil) ? [[SDLMetadataTags alloc] initWithTextFieldTypes:field1Array mainField2:field2Array mainField3:field3Array mainField4:field4Array] : nil;

    self.mainField1 = mainField1;
    self.mainField2 = mainField2;
    self.mainField3 = mainField3;
    self.mainField4 = mainField4;
    self.alignment = alignment;
    self.metadataTags = metadataTags;

    return self;
}

- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField2:(nullable NSString *)mainField2 alignment:(nullable SDLTextAlignment)alignment statusBar:(nullable NSString *)statusBar mediaClock:(nullable NSString *)mediaClock mediaTrack:(nullable NSString *)mediaTrack {
    return [self initWithMainField1:mainField1 mainField2:mainField2 mainField3:nil mainField4:nil alignment:alignment statusBar:statusBar mediaClock:mediaClock mediaTrack:mediaTrack graphic:nil softButtons:nil customPresets:nil textFieldMetadata:nil];
}

- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField2:(nullable NSString *)mainField2 mainField3:(nullable NSString *)mainField3 mainField4:(nullable NSString *)mainField4 alignment:(nullable SDLTextAlignment)alignment statusBar:(nullable NSString *)statusBar mediaClock:(nullable NSString *)mediaClock mediaTrack:(nullable NSString *)mediaTrack graphic:(nullable SDLImage *)graphic softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons customPresets:(nullable NSArray<NSString *> *)customPresets textFieldMetadata:(nullable SDLMetadataTags *)metadata {
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

- (void)setMainField1:(nullable NSString *)mainField1 {
    [self.parameters sdl_setObject:mainField1 forName:SDLRPCParameterNameMainField1];
}

- (nullable NSString *)mainField1 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMainField1 ofClass:NSString.class error:nil];
}

- (void)setMainField2:(nullable NSString *)mainField2 {
    [self.parameters sdl_setObject:mainField2 forName:SDLRPCParameterNameMainField2];
}

- (nullable NSString *)mainField2 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMainField2 ofClass:NSString.class error:nil];
}

- (void)setMainField3:(nullable NSString *)mainField3 {
    [self.parameters sdl_setObject:mainField3 forName:SDLRPCParameterNameMainField3];
}

- (nullable NSString *)mainField3 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMainField3 ofClass:NSString.class error:nil];
}

- (void)setMainField4:(nullable NSString *)mainField4 {
    [self.parameters sdl_setObject:mainField4 forName:SDLRPCParameterNameMainField4];
}

- (nullable NSString *)mainField4 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMainField4 ofClass:NSString.class error:nil];
}

- (void)setAlignment:(nullable SDLTextAlignment)alignment {
    [self.parameters sdl_setObject:alignment forName:SDLRPCParameterNameAlignment];
}

- (nullable SDLTextAlignment)alignment {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameAlignment error:nil];
}

- (void)setStatusBar:(nullable NSString *)statusBar {
    [self.parameters sdl_setObject:statusBar forName:SDLRPCParameterNameStatusBar];
}

- (nullable NSString *)statusBar {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameStatusBar ofClass:NSString.class error:nil];
}

- (void)setMediaClock:(nullable NSString *)mediaClock {
    [self.parameters sdl_setObject:mediaClock forName:SDLRPCParameterNameMediaClock];
}

- (nullable NSString *)mediaClock {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMediaClock ofClass:NSString.class error:nil];
}

- (void)setMediaTrack:(nullable NSString *)mediaTrack {
    [self.parameters sdl_setObject:mediaTrack forName:SDLRPCParameterNameMediaTrack];
}

- (nullable NSString *)mediaTrack {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMediaTrack ofClass:NSString.class error:nil];
}

- (void)setGraphic:(nullable SDLImage *)graphic {
    [self.parameters sdl_setObject:graphic forName:SDLRPCParameterNameGraphic];
}

- (nullable SDLImage *)graphic {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGraphic ofClass:SDLImage.class error:nil];
}

- (void)setSecondaryGraphic:(nullable SDLImage *)secondaryGraphic {
    [self.parameters sdl_setObject:secondaryGraphic forName:SDLRPCParameterNameSecondaryGraphic];
}

- (nullable SDLImage *)secondaryGraphic {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSecondaryGraphic ofClass:SDLImage.class error:nil];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [self.parameters sdl_setObject:softButtons forName:SDLRPCParameterNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameSoftButtons ofClass:SDLSoftButton.class error:nil];
}

- (void)setCustomPresets:(nullable NSArray<NSString *> *)customPresets {
    [self.parameters sdl_setObject:customPresets forName:SDLRPCParameterNameCustomPresets];
}

- (nullable NSArray<NSString *> *)customPresets {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameCustomPresets ofClass:NSString.class error:nil];
}

- (void)setMetadataTags:(nullable SDLMetadataTags *)metadataTags {
    [self.parameters sdl_setObject:metadataTags forName:SDLRPCParameterNameMetadataTags];
}

- (nullable SDLMetadataTags *)metadataTags {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMetadataTags ofClass:SDLMetadataTags.class error:nil];
}

- (void)setWindowID:(nullable NSNumber<SDLUInt> *)windowID {
    [self.parameters sdl_setObject:windowID forName:SDLRPCParameterNameWindowId];
}

- (nullable NSNumber<SDLUInt> *)windowID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWindowId ofClass:NSNumber.class error:&error];
}

- (void)setTemplateConfiguration:(nullable SDLTemplateConfiguration *)templateConfiguration {
    [self.parameters sdl_setObject:templateConfiguration forName:SDLRPCParameterNameTemplateConfiguration];
}

- (nullable SDLTemplateConfiguration *)templateConfiguration {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTemplateConfiguration ofClass:SDLTemplateConfiguration.class error:nil];
}

- (void)setTemplateTitle:(nullable NSString *)templateTitle {
    [self.parameters sdl_setObject:templateTitle forName:SDLRPCParameterNameTemplateTitle];
}

- (nullable NSString *)templateTitle {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTemplateTitle ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
