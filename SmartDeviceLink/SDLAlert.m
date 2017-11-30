//  SDLAlert.m

#import "SDLAlert.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

static UInt16 const SDLDefaultDuration = 5000;

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlert

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlert]) {
    }
    return self;
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 duration:SDLDefaultDuration];
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:nil duration:duration];
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 duration:duration softButtons:nil];
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 duration:(UInt16)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self initWithTTSChunks:nil alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:NO duration:duration softButtons:softButtons];
}

- (instancetype)initWithTTS:(nullable NSString *)ttsText playTone:(BOOL)playTone {
    return [self initWithTTS:ttsText alertText1:nil alertText2:nil playTone:playTone duration:SDLDefaultDuration];
}

- (instancetype)initWithTTS:(nullable NSString *)ttsText alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 playTone:(BOOL)playTone duration:(UInt16)duration {
    return [self initWithTTS:ttsText alertText1:alertText1 alertText2:alertText2 alertText3:nil playTone:playTone duration:duration];
}

- (instancetype)initWithTTS:(nullable NSString *)ttsText alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration {
    NSArray *ttsChunks = [SDLTTSChunk textChunksFromString:ttsText];
    return [self initWithTTSChunks:ttsChunks alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:playTone duration:duration softButtons:nil];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks playTone:(BOOL)playTone {
    return [self initWithTTSChunks:ttsChunks alertText1:nil alertText2:nil alertText3:nil playTone:playTone duration:SDLDefaultDuration softButtons:nil];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self initWithTTSChunks:ttsChunks alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:playTone duration:SDLDefaultDuration softButtons:softButtons];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ttsChunks = [ttsChunks mutableCopy];
    self.alertText1 = alertText1;
    self.alertText2 = alertText2;
    self.alertText3 = alertText3;
    self.playTone = @(playTone);
    self.duration = @(duration);
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (void)setAlertText1:(nullable NSString *)alertText1 {
    [parameters sdl_setObject:alertText1 forName:SDLNameAlertText1];
}

- (nullable NSString *)alertText1 {
    return [parameters sdl_objectForName:SDLNameAlertText1];
}

- (void)setAlertText2:(nullable NSString *)alertText2 {
    [parameters sdl_setObject:alertText2 forName:SDLNameAlertText2];
}

- (nullable NSString *)alertText2 {
    return [parameters sdl_objectForName:SDLNameAlertText2];
}

- (void)setAlertText3:(nullable NSString *)alertText3 {
    [parameters sdl_setObject:alertText3 forName:SDLNameAlertText3];
}

- (nullable NSString *)alertText3 {
    return [parameters sdl_objectForName:SDLNameAlertText3];
}

- (void)setTtsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    [parameters sdl_setObject:ttsChunks forName:SDLNameTTSChunks];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    return [parameters sdl_objectsForName:SDLNameTTSChunks ofClass:SDLTTSChunk.class];
}

- (void)setDuration:(nullable NSNumber<SDLInt> *)duration {
    [parameters sdl_setObject:duration forName:SDLNameDuration];
}

- (nullable NSNumber<SDLInt> *)duration {
    return [parameters sdl_objectForName:SDLNameDuration];
}

- (void)setPlayTone:(nullable NSNumber<SDLBool> *)playTone {
    [parameters sdl_setObject:playTone forName:SDLNamePlayTone];
}

- (nullable NSNumber<SDLBool> *)playTone {
    return [parameters sdl_objectForName:SDLNamePlayTone];
}

- (void)setProgressIndicator:(nullable NSNumber<SDLBool> *)progressIndicator {
    [parameters sdl_setObject:progressIndicator forName:SDLNameProgressIndicator];
}

- (nullable NSNumber<SDLBool> *)progressIndicator {
    return [parameters sdl_objectForName:SDLNameProgressIndicator];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [parameters sdl_setObject:softButtons forName:SDLNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [parameters sdl_objectsForName:SDLNameSoftButtons ofClass:SDLSoftButton.class];
}

@end

NS_ASSUME_NONNULL_END
