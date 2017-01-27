//  SDLDiagnosticMessage.m
//


#import "SDLDiagnosticMessage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDiagnosticMessage

- (instancetype)init {
    if (self = [super initWithName:SDLNameDiagnosticMessage]) {
    }
    return self;
}

- (instancetype)initWithTargetId:(UInt16)targetId length:(UInt16)length data:(NSArray<NSData *> *)data {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.targetID = @(targetId);
    self.messageLength = @(length);
    self.messageData = [data mutableCopy];

    return self;
}

- (void)setTargetID:(NSNumber<SDLInt> *)targetID {
    [parameters sdl_setObject:targetID forName:SDLNameTargetId];
}

- (NSNumber<SDLInt> *)targetID {
    return [parameters sdl_objectForName:SDLNameTargetId];
}

- (void)setMessageLength:(NSNumber<SDLInt> *)messageLength {
    [parameters sdl_setObject:messageLength forName:SDLNameMessageLength];
}

- (NSNumber<SDLInt> *)messageLength {
    return [parameters sdl_objectForName:SDLNameMessageLength];
}

- (void)setMessageData:(NSArray<NSNumber<SDLInt> *> *)messageData {
    [parameters sdl_setObject:messageData forName:SDLNameMessageData];
}

- (NSArray<NSNumber<SDLInt> *> *)messageData {
    return [parameters sdl_objectForName:SDLNameMessageData];
}

@end

NS_ASSUME_NONNULL_END
