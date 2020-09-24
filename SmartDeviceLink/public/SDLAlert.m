//  SDLAlert.m

#import "SDLAlert.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"


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

- (instancetype)initWithAlertText:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons playTone:(BOOL)playTone ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks duration:(nullable NSNumber *)duration progressIndicator:(BOOL)progressIndicator alertIcon:(nullable SDLImage *)icon cancelID:(nullable NSNumber *)cancelID {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.alertText1 = alertText1;
    self.alertText2 = alertText2;
    self.alertText3 = alertText3;
    self.ttsChunks = ttsChunks;
    self.duration = duration;
    self.playTone = @(playTone);
    self.progressIndicator = @(progressIndicator);
    self.softButtons = softButtons;
    self.alertIcon = icon;
    self.cancelID = cancelID;

    return self;
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons playTone:(BOOL)playTone ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks duration:(UInt16)duration progressIndicator:(BOOL)progressIndicator alertIcon:(nullable SDLImage *)icon cancelID:(UInt32)cancelID {
    return [self initWithAlertText:alertText1 alertText2:alertText2 alertText3:alertText3 softButtons:softButtons playTone:playTone ttsChunks:ttsChunks duration:@(duration) progressIndicator:progressIndicator alertIcon:icon cancelID:@(cancelID)];
}

- (instancetype)initWithAlertText:(nullable NSString *)alertText softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons playTone:(BOOL)playTone ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertIcon:(nullable SDLImage *)icon cancelID:(UInt32)cancelID {
    return [self initWithAlertText:alertText alertText2:nil alertText3:nil softButtons:softButtons playTone:playTone ttsChunks:ttsChunks duration:nil progressIndicator:false alertIcon:icon cancelID:@(cancelID)];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks playTone:(BOOL)playTone {
    return [self initWithAlertText:nil alertText2:nil alertText3:nil softButtons:nil playTone:playTone ttsChunks:ttsChunks duration:nil progressIndicator:false alertIcon:nil cancelID:nil];
}

#pragma mark - Getters and Setters

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

- (void)setCancelID:(nullable NSNumber<SDLInt> *)cancelID {
    [self.parameters sdl_setObject:cancelID forName:SDLRPCParameterNameCancelID];
}

- (nullable NSNumber<SDLInt> *)cancelID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCancelID ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
