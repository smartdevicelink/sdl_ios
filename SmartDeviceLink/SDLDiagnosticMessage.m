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

- (void)setTargetID:(NSNumber<SDLInt> *)targetID {
    if (targetID != nil) {
        [parameters setObject:targetID forKey:SDLNameTargetId];
    } else {
        [parameters removeObjectForKey:SDLNameTargetId];
    }
}

- (NSNumber<SDLInt> *)targetID {
    return [parameters objectForKey:SDLNameTargetId];
}

- (void)setMessageLength:(NSNumber<SDLInt> *)messageLength {
    if (messageLength != nil) {
        [parameters setObject:messageLength forKey:SDLNameMessageLength];
    } else {
        [parameters removeObjectForKey:SDLNameMessageLength];
    }
}

- (NSNumber<SDLInt> *)messageLength {
    return [parameters objectForKey:SDLNameMessageLength];
}

- (void)setMessageData:(NSMutableArray<NSNumber<SDLInt> *> *)messageData {
    if (messageData != nil) {
        [parameters setObject:messageData forKey:SDLNameMessageData];
    } else {
        [parameters removeObjectForKey:SDLNameMessageData];
    }
}

- (NSMutableArray<NSNumber<SDLInt> *> *)messageData {
    return [parameters objectForKey:SDLNameMessageData];
}

@end
