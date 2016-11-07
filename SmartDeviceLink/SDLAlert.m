//  SDLAlert.m

#import "SDLAlert.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"
#import "SDLTTSChunkFactory.h"

static UInt16 const SDLDefaultDuration = 5000;

@implementation SDLAlert

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlert]) {
    }
    return self;
}

- (instancetype)initWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 duration:SDLDefaultDuration];
}

- (instancetype)initWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:nil duration:duration];
}

- (instancetype)initWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 duration:duration softButtons:nil];
}

- (instancetype)initWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 duration:(UInt16)duration softButtons:(NSArray<SDLSoftButton *> *)softButtons {
    return [self initWithTTSChunks:nil alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:NO duration:duration softButtons:softButtons];
}

- (instancetype)initWithTTS:(NSString *)ttsText playTone:(BOOL)playTone {
    return [self initWithTTS:ttsText alertText1:nil alertText2:nil playTone:playTone duration:SDLDefaultDuration];
}

- (instancetype)initWithTTS:(NSString *)ttsText alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 playTone:(BOOL)playTone duration:(UInt16)duration {
    return [self initWithTTS:ttsText alertText1:alertText1 alertText2:alertText2 alertText3:nil playTone:playTone duration:duration];
}

- (instancetype)initWithTTS:(NSString *)ttsText alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration {
    NSMutableArray *ttsChunks = [SDLTTSChunk textChunksFromString:ttsText];
    return [self initWithTTSChunks:ttsChunks alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:playTone duration:duration softButtons:nil];
}

- (instancetype)initWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks playTone:(BOOL)playTone {
    return [self initWithTTSChunks:ttsChunks alertText1:nil alertText2:nil alertText3:nil playTone:playTone duration:SDLDefaultDuration softButtons:nil];
}

- (instancetype)initWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 playTone:(BOOL)playTone softButtons:(NSArray<SDLSoftButton *> *)softButtons {
    return [self initWithTTSChunks:ttsChunks alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:playTone duration:SDLDefaultDuration softButtons:softButtons];
}

- (instancetype)initWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration softButtons:(NSArray<SDLSoftButton *> *)softButtons {
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

- (void)setAlertText1:(NSString *)alertText1 {
    [self setObject:alertText1 forName:SDLNameAlertText1];
}

- (NSString *)alertText1 {
    return [parameters objectForKey:SDLNameAlertText1];
}

- (void)setAlertText2:(NSString *)alertText2 {
    [self setObject:alertText2 forName:SDLNameAlertText2];
}

- (NSString *)alertText2 {
    return [parameters objectForKey:SDLNameAlertText2];
}

- (void)setAlertText3:(NSString *)alertText3 {
    [self setObject:alertText3 forName:SDLNameAlertText3];
}

- (NSString *)alertText3 {
    return [parameters objectForKey:SDLNameAlertText3];
}

- (void)setTtsChunks:(NSMutableArray<SDLTTSChunk *> *)ttsChunks {
    [self setObject:ttsChunks forName:SDLNameTTSChunks];
}

- (NSMutableArray<SDLTTSChunk *> *)ttsChunks {
    return [self objectsForName:SDLNameTTSChunks ofClass:SDLTTSChunk.class];
}

- (void)setDuration:(NSNumber<SDLInt> *)duration {
    [self setObject:duration forName:SDLNameDuration];
}

- (NSNumber<SDLInt> *)duration {
    return [parameters objectForKey:SDLNameDuration];
}

- (void)setPlayTone:(NSNumber<SDLBool> *)playTone {
    [self setObject:playTone forName:SDLNamePlayTone];
}

- (NSNumber<SDLBool> *)playTone {
    return [parameters objectForKey:SDLNamePlayTone];
}

- (void)setProgressIndicator:(NSNumber<SDLBool> *)progressIndicator {
    [self setObject:progressIndicator forName:SDLNameProgressIndicator];
}

- (NSNumber<SDLBool> *)progressIndicator {
    return [parameters objectForKey:SDLNameProgressIndicator];
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    [self setObject:softButtons forName:SDLNameSoftButtons];
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    return [self objectsForName:SDLNameSoftButtons ofClass:SDLSoftButton.class];
}

@end
