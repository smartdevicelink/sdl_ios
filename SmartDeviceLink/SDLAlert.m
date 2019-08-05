//  SDLAlert.m

#import "SDLAlert.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

static UInt16 const DefaultAlertDuration = 5000;

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlert

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAlert]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 ttsChunks:nil playTone:NO progressIndicator:NO duration:DefaultAlertDuration softButtons:nil alertIcon:nil];
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:nil ttsChunks:nil playTone:NO progressIndicator:NO duration:duration softButtons:nil alertIcon:nil];

}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 ttsChunks:nil playTone:NO progressIndicator:NO duration:duration softButtons:nil alertIcon:nil];
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 duration:(UInt16)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 ttsChunks:nil playTone:NO progressIndicator:NO duration:duration softButtons:softButtons alertIcon:nil];
}

- (instancetype)initWithTTS:(nullable NSString *)ttsText playTone:(BOOL)playTone {
    return [self initWithAlertText1:nil alertText2:nil alertText3:nil ttsChunks:[SDLTTSChunk textChunksFromString:ttsText] playTone:playTone progressIndicator:NO duration:DefaultAlertDuration softButtons:nil alertIcon:nil];
}

- (instancetype)initWithTTS:(nullable NSString *)ttsText alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 playTone:(BOOL)playTone duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:nil ttsChunks:[SDLTTSChunk textChunksFromString:ttsText] playTone:playTone progressIndicator:NO duration:duration softButtons:nil alertIcon:nil];
}

- (instancetype)initWithTTS:(nullable NSString *)ttsText alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 ttsChunks:[SDLTTSChunk textChunksFromString:ttsText] playTone:playTone progressIndicator:NO duration:duration softButtons:nil alertIcon:nil];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 ttsChunks:ttsChunks playTone:playTone progressIndicator:NO duration:DefaultAlertDuration softButtons:softButtons alertIcon:nil];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 ttsChunks:ttsChunks playTone:playTone progressIndicator:NO duration:duration softButtons:softButtons alertIcon:nil];
}

- (instancetype)initWithAlertText1:(NSString *)alertText1 alertText2:(nullable NSString *)alertText2 {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:nil ttsChunks:nil playTone:NO progressIndicator:NO duration:DefaultAlertDuration softButtons:nil alertIcon:nil];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks playTone:(BOOL)playTone {
    return [self initWithAlertText1:nil alertText2:nil alertText3:nil ttsChunks:ttsChunks playTone:playTone progressIndicator:NO duration:DefaultAlertDuration softButtons:nil alertIcon:nil];
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks playTone:(BOOL)playTone progressIndicator:(BOOL)showProgressIndicator duration:(UInt16)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons alertIcon:(nullable SDLImage *)icon {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ttsChunks = [ttsChunks copy];
    self.alertText1 = alertText1;
    self.alertText2 = alertText2;
    self.alertText3 = alertText3;
    self.playTone = @(playTone);
    self.progressIndicator = @(showProgressIndicator);
    self.duration = @(duration);
    self.softButtons = [softButtons copy];
    self.alertIcon = icon;

    return self;
}

- (void)setAlertText1:(nullable NSString *)alertText1 {
    [self.parameters sdl_setObject:alertText1 forName:SDLRPCParameterNameAlertText1];
}

- (nullable NSString *)alertText1 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAlertText1 ofClass:NSString.class error:nil];
}

- (void)setAlertText2:(nullable NSString *)alertText2 {
    [self.parameters sdl_setObject:alertText2 forName:SDLRPCParameterNameAlertText2];
}

- (nullable NSString *)alertText2 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAlertText2 ofClass:NSString.class error:nil];
}

- (void)setAlertText3:(nullable NSString *)alertText3 {
    [self.parameters sdl_setObject:alertText3 forName:SDLRPCParameterNameAlertText3];
}

- (nullable NSString *)alertText3 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAlertText3 ofClass:NSString.class error:nil];
}

- (void)setTtsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    [self.parameters sdl_setObject:ttsChunks forName:SDLRPCParameterNameTTSChunks];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameTTSChunks ofClass:SDLTTSChunk.class error:nil];
}

- (void)setDuration:(nullable NSNumber<SDLInt> *)duration {
    [self.parameters sdl_setObject:duration forName:SDLRPCParameterNameDuration];
}

- (nullable NSNumber<SDLInt> *)duration {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDuration ofClass:NSNumber.class error:nil];
}

- (void)setPlayTone:(nullable NSNumber<SDLBool> *)playTone {
    [self.parameters sdl_setObject:playTone forName:SDLRPCParameterNamePlayTone];
}

- (nullable NSNumber<SDLBool> *)playTone {
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePlayTone ofClass:NSNumber.class error:nil];
}

- (void)setProgressIndicator:(nullable NSNumber<SDLBool> *)progressIndicator {
    [self.parameters sdl_setObject:progressIndicator forName:SDLRPCParameterNameProgressIndicator];
}

- (nullable NSNumber<SDLBool> *)progressIndicator {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameProgressIndicator ofClass:NSNumber.class error:nil];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [self.parameters sdl_setObject:softButtons forName:SDLRPCParameterNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameSoftButtons ofClass:SDLSoftButton.class error:nil];
}

- (void)setAlertIcon:(nullable SDLImage *)alertIcon {
    [self.parameters sdl_setObject:alertIcon forName:SDLRPCParameterNameAlertIcon];
}

- (nullable SDLImage *)alertIcon {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAlertIcon ofClass:SDLImage.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
