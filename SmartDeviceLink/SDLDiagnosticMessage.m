//  SDLDiagnosticMessage.m
//


#import "SDLDiagnosticMessage.h"

#import "SDLNames.h"

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
    [self setObject:targetID forName:SDLNameTargetId];
}

- (NSNumber<SDLInt> *)targetID {
    return [parameters objectForKey:SDLNameTargetId];
}

- (void)setMessageLength:(NSNumber<SDLInt> *)messageLength {
    [self setObject:messageLength forName:SDLNameMessageLength];
}

- (NSNumber<SDLInt> *)messageLength {
    return [parameters objectForKey:SDLNameMessageLength];
}

- (void)setMessageData:(NSMutableArray<NSNumber<SDLInt> *> *)messageData {
    [self setObject:messageData forName:SDLNameMessageData];
}

- (NSMutableArray<NSNumber<SDLInt> *> *)messageData {
    return [parameters objectForKey:SDLNameMessageData];
}

@end
