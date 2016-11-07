//  SDLAlertManeuver.m
//


#import "SDLAlertManeuver.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

@implementation SDLAlertManeuver

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlertManeuver]) {
    }
    return self;
}


- (instancetype)initWithTTS:(NSString *)ttsText softButtons:(NSArray<SDLSoftButton *> *)softButtons {
    NSMutableArray *ttsChunks = [SDLTTSChunk textChunksFromString:ttsText];
    return [self initWithTTSChunks:ttsChunks softButtons:softButtons];
}

- (instancetype)initWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks softButtons:(NSArray<SDLSoftButton *> *)softButtons {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ttsChunks = [ttsChunks mutableCopy];
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (void)setTtsChunks:(NSMutableArray<SDLTTSChunk *> *)ttsChunks {
    [self setObject:ttsChunks forName:SDLNameTTSChunks];
}

- (NSMutableArray<SDLTTSChunk *> *)ttsChunks {
    return [self objectsForName:SDLNameTTSChunks ofClass:SDLTTSChunk.class];
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    [self setObject:softButtons forName:SDLNameSoftButtons];
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    return [self objectsForName:SDLNameSoftButtons ofClass:SDLSoftButton.class];
}

@end
