//  SDLAlert.m

#import "SDLAlert.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"
#import "SDLTTSChunkFactory.h"

static UInt16 const SDLDefaultDuration = 5000;

@implementation SDLAlert

- (instancetype)init {
    if (self = [super initWithName:NAMES_Alert]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
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
        [parameters setObject:alertText1 forKey:NAMES_alertText1];
    } else {
        [parameters removeObjectForKey:NAMES_alertText1];
    }
}

- (NSString *)alertText1 {
    return [parameters objectForKey:NAMES_alertText1];
}

- (void)setAlertText2:(NSString *)alertText2 {
    if (alertText2 != nil) {
        [parameters setObject:alertText2 forKey:NAMES_alertText2];
    } else {
        [parameters removeObjectForKey:NAMES_alertText2];
    }
}

- (NSString *)alertText2 {
    return [parameters objectForKey:NAMES_alertText2];
}

- (void)setAlertText3:(NSString *)alertText3 {
    if (alertText3 != nil) {
        [parameters setObject:alertText3 forKey:NAMES_alertText3];
    } else {
        [parameters removeObjectForKey:NAMES_alertText3];
    }
}

- (NSString *)alertText3 {
    return [parameters objectForKey:NAMES_alertText3];
}

- (void)setTtsChunks:(NSMutableArray *)ttsChunks {
    if (ttsChunks != nil) {
        [parameters setObject:ttsChunks forKey:NAMES_ttsChunks];
    } else {
        [parameters removeObjectForKey:NAMES_ttsChunks];
    }
}

- (NSMutableArray *)ttsChunks {
    NSMutableArray *array = [parameters objectForKey:NAMES_ttsChunks];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setDuration:(NSNumber *)duration {
    if (duration != nil) {
        [parameters setObject:duration forKey:NAMES_duration];
    } else {
        [parameters removeObjectForKey:NAMES_duration];
    }
}

- (NSNumber *)duration {
    return [parameters objectForKey:NAMES_duration];
}

- (void)setPlayTone:(NSNumber *)playTone {
    if (playTone != nil) {
        [parameters setObject:playTone forKey:NAMES_playTone];
    } else {
        [parameters removeObjectForKey:NAMES_playTone];
    }
}

- (NSNumber *)playTone {
    return [parameters objectForKey:NAMES_playTone];
}

- (void)setProgressIndicator:(NSNumber *)progressIndicator {
    if (progressIndicator != nil) {
        [parameters setObject:progressIndicator forKey:NAMES_progressIndicator];
    } else {
        [parameters removeObjectForKey:NAMES_progressIndicator];
    }
}

- (NSNumber *)progressIndicator {
    return [parameters objectForKey:NAMES_progressIndicator];
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

@end
