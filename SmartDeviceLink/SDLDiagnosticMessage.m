//  SDLDiagnosticMessage.m
//


#import "SDLDiagnosticMessage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDiagnosticMessage

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDiagnosticMessage]) {
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
    [parameters sdl_setObject:targetID forName:SDLRPCParameterNameTargetId];
}

- (NSNumber<SDLInt> *)targetID {
    return [parameters sdl_objectForName:SDLRPCParameterNameTargetId];
}

- (void)setMessageLength:(NSNumber<SDLInt> *)messageLength {
    [parameters sdl_setObject:messageLength forName:SDLRPCParameterNameMessageLength];
}

- (NSNumber<SDLInt> *)messageLength {
    return [parameters sdl_objectForName:SDLRPCParameterNameMessageLength];
}

- (void)setMessageData:(NSArray<NSNumber<SDLInt> *> *)messageData {
    [parameters sdl_setObject:messageData forName:SDLRPCParameterNameMessageData];
}

- (NSArray<NSNumber<SDLInt> *> *)messageData {
    return [parameters sdl_objectForName:SDLRPCParameterNameMessageData];
}

@end

NS_ASSUME_NONNULL_END
