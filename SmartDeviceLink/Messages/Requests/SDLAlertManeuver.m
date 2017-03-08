//  SDLAlertManeuver.m
//


#import "SDLAlertManeuver.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlertManeuver

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlertManeuver]) {
    }
    return self;
}


- (instancetype)initWithTTS:(nullable NSString *)ttsText softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    NSArray *ttsChunks = [SDLTTSChunk textChunksFromString:ttsText];
    return [self initWithTTSChunks:ttsChunks softButtons:softButtons];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ttsChunks = [ttsChunks mutableCopy];
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (void)setTtsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    [parameters sdl_setObject:ttsChunks forName:SDLNameTTSChunks];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    return [parameters sdl_objectsForName:SDLNameTTSChunks ofClass:SDLTTSChunk.class];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [parameters sdl_setObject:softButtons forName:SDLNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [parameters sdl_objectsForName:SDLNameSoftButtons ofClass:SDLSoftButton.class];
}

@end

NS_ASSUME_NONNULL_END
