//  SDLAlert.m

#import "SDLAlert.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

@implementation SDLAlert

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlert]) {
    }
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
