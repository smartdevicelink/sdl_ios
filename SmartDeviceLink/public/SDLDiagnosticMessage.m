//  SDLDiagnosticMessage.m
//


#import "SDLDiagnosticMessage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDiagnosticMessage

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDiagnosticMessage]) {
    }
    return self;
}
#pragma clang diagnostic pop

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
    [self.parameters sdl_setObject:targetID forName:SDLRPCParameterNameTargetId];
}

- (NSNumber<SDLInt> *)targetID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTargetId ofClass:NSNumber.class error:&error];
}

- (void)setMessageLength:(NSNumber<SDLInt> *)messageLength {
    [self.parameters sdl_setObject:messageLength forName:SDLRPCParameterNameMessageLength];
}

- (NSNumber<SDLInt> *)messageLength {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMessageLength ofClass:NSNumber.class error:&error];
}

- (void)setMessageData:(NSArray<NSNumber *> *)messageData {
    [self.parameters sdl_setObject:messageData forName:SDLRPCParameterNameMessageData];
}

- (NSArray<NSNumber *> *)messageData {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameMessageData ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
