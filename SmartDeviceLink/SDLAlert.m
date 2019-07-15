//  SDLAlert.m

#import "SDLAlert.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

static UInt16 const SDLDefaultDuration = 5000;

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

- (instancetype)initWithAlertText:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons playTone:(BOOL)playTone ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks duration:(nullable NSNumber *)duration progressIndicator:(BOOL)progressIndicator cancelID:(nullable NSNumber *)cancelID {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.alertText1 = alertText1;
    self.alertText2 = alertText2;
    self.alertText3 = alertText3;
    self.ttsChunks = [ttsChunks mutableCopy];
    self.duration = duration;
    self.playTone = @(playTone);
    self.progressIndicator = @(progressIndicator);
    self.softButtons = [softButtons mutableCopy];
    self.cancelID = cancelID;

    return self;
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons playTone:(BOOL)playTone ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks duration:(UInt16)duration progressIndicator:(BOOL)progressIndicator cancelID:(UInt32)cancelID {
    return [self initWithAlertText:alertText1 alertText2:alertText2 alertText3:alertText3 softButtons:softButtons playTone:playTone ttsChunks:ttsChunks duration:@(duration) progressIndicator:progressIndicator cancelID:@(cancelID)];
}

- (instancetype)initWithTTS:(NSArray<SDLTTSChunk *> *)ttsChunks playTone:(BOOL)playTone cancelID:(UInt32)cancelID {
    return [self initWithAlertText:nil alertText2:nil alertText3:nil softButtons:nil playTone:playTone ttsChunks:ttsChunks duration:nil progressIndicator:false cancelID:@(cancelID)];
}

- (instancetype)initWithAlertText:(nullable NSString *)alertText softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons playTone:(BOOL)playTone ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks cancelID:(UInt32)cancelID {
    return [self initWithAlertText:alertText alertText2:nil alertText3:nil softButtons:softButtons playTone:playTone ttsChunks:ttsChunks duration:nil progressIndicator:false cancelID:@(cancelID)];
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
    return [self initWithAlertText:alertText1 alertText2:alertText2 alertText3:alertText3 softButtons:softButtons playTone:playTone ttsChunks:ttsChunks duration:@(duration) progressIndicator:false cancelID:nil];
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

- (void)setCancelID:(nullable NSNumber<SDLInt> *)cancelID {
    [self.parameters sdl_setObject:cancelID forName:SDLRPCParameterNameCancelID];
}

- (nullable NSNumber<SDLInt> *)cancelID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCancelID ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
