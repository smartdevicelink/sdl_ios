//  SDLAlert.m

#import "SDLAlert.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

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
    if (alertText1 != nil) {
        [parameters setObject:alertText1 forKey:SDLNameAlertText1];
    } else {
        [parameters removeObjectForKey:SDLNameAlertText1];
    }
}

- (NSString *)alertText1 {
    return [parameters objectForKey:SDLNameAlertText1];
}

- (void)setAlertText2:(NSString *)alertText2 {
    if (alertText2 != nil) {
        [parameters setObject:alertText2 forKey:SDLNameAlertText2];
    } else {
        [parameters removeObjectForKey:SDLNameAlertText2];
    }
}

- (NSString *)alertText2 {
    return [parameters objectForKey:SDLNameAlertText2];
}

- (void)setAlertText3:(NSString *)alertText3 {
    if (alertText3 != nil) {
        [parameters setObject:alertText3 forKey:SDLNameAlertText3];
    } else {
        [parameters removeObjectForKey:SDLNameAlertText3];
    }
}

- (NSString *)alertText3 {
    return [parameters objectForKey:SDLNameAlertText3];
}

- (void)setTtsChunks:(NSMutableArray<SDLTTSChunk *> *)ttsChunks {
    if (ttsChunks != nil) {
        [parameters setObject:ttsChunks forKey:SDLNameTTSChunks];
    } else {
        [parameters removeObjectForKey:SDLNameTTSChunks];
    }
}

- (NSMutableArray<SDLTTSChunk *> *)ttsChunks {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameTTSChunks];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:dict]];
        }
        return newList;
    }
}

- (void)setDuration:(NSNumber<SDLInt> *)duration {
    if (duration != nil) {
        [parameters setObject:duration forKey:SDLNameDuration];
    } else {
        [parameters removeObjectForKey:SDLNameDuration];
    }
}

- (NSNumber<SDLInt> *)duration {
    return [parameters objectForKey:SDLNameDuration];
}

- (void)setPlayTone:(NSNumber<SDLBool> *)playTone {
    if (playTone != nil) {
        [parameters setObject:playTone forKey:SDLNamePlayTone];
    } else {
        [parameters removeObjectForKey:SDLNamePlayTone];
    }
}

- (NSNumber<SDLBool> *)playTone {
    return [parameters objectForKey:SDLNamePlayTone];
}

- (void)setProgressIndicator:(NSNumber<SDLBool> *)progressIndicator {
    if (progressIndicator != nil) {
        [parameters setObject:progressIndicator forKey:SDLNameProgressIndicator];
    } else {
        [parameters removeObjectForKey:SDLNameProgressIndicator];
    }
}

- (NSNumber<SDLBool> *)progressIndicator {
    return [parameters objectForKey:SDLNameProgressIndicator];
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    NSMutableArray<SDLSoftButton *> *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButton *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:dict]];
        }
        return newList;
    }
}

@end
