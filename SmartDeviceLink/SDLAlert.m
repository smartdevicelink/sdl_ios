//  SDLAlert.m

#import "SDLAlert.h"


#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

@implementation SDLAlert

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlert]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
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

- (void)setTtsChunks:(NSMutableArray *)ttsChunks {
    if (ttsChunks != nil) {
        [parameters setObject:ttsChunks forKey:SDLNameTtsChunks];
    } else {
        [parameters removeObjectForKey:SDLNameTtsChunks];
    }
}

- (NSMutableArray *)ttsChunks {
    NSMutableArray *array = [parameters objectForKey:SDLNameTtsChunks];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
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
        [parameters setObject:duration forKey:SDLNameDuration];
    } else {
        [parameters removeObjectForKey:SDLNameDuration];
    }
}

- (NSNumber *)duration {
    return [parameters objectForKey:SDLNameDuration];
}

- (void)setPlayTone:(NSNumber *)playTone {
    if (playTone != nil) {
        [parameters setObject:playTone forKey:SDLNamePlayTone];
    } else {
        [parameters removeObjectForKey:SDLNamePlayTone];
    }
}

- (NSNumber *)playTone {
    return [parameters objectForKey:SDLNamePlayTone];
}

- (void)setProgressIndicator:(NSNumber *)progressIndicator {
    if (progressIndicator != nil) {
        [parameters setObject:progressIndicator forKey:SDLNameProgressIndicator];
    } else {
        [parameters removeObjectForKey:SDLNameProgressIndicator];
    }
}

- (NSNumber *)progressIndicator {
    return [parameters objectForKey:SDLNameProgressIndicator];
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (NSMutableArray *)softButtons {
    NSMutableArray *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
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
