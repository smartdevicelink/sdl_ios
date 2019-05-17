//  SDLSpeak.m
//


#import "SDLSpeak.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSpeak

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSpeak]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithTTS:(NSString *)ttsText {
    NSArray *ttsChunks = [SDLTTSChunk textChunksFromString:ttsText];
    return [self initWithTTSChunks:ttsChunks];
}

- (instancetype)initWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ttsChunks = [ttsChunks mutableCopy];

    return self;
}

- (void)setTtsChunks:(NSArray<SDLTTSChunk *> *)ttsChunks {
    [self.parameters sdl_setObject:ttsChunks forName:SDLRPCParameterNameTTSChunks];
}

- (NSArray<SDLTTSChunk *> *)ttsChunks {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameTTSChunks ofClass:SDLTTSChunk.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
