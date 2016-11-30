//  SDLDiagnosticMessage.m
//


#import "SDLDiagnosticMessage.h"

#import "SDLNames.h"

@implementation SDLDiagnosticMessage

- (instancetype)init {
    if (self = [super initWithName:NAMES_DiagnosticMessage]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithTargetId:(UInt16)targetId length:(UInt16)length data:(NSArray<NSNumber<SDLUInt> *> *)data {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.targetID = @(targetId);
    self.messageLength = @(length);
    self.messageData = [data mutableCopy];

    return self;
}

- (void)setTargetID:(NSNumber *)targetID {
    if (targetID != nil) {
        [parameters setObject:targetID forKey:NAMES_targetID];
    } else {
        [parameters removeObjectForKey:NAMES_targetID];
    }
}

- (NSNumber *)targetID {
    return [parameters objectForKey:NAMES_targetID];
}

- (void)setMessageLength:(NSNumber *)messageLength {
    if (messageLength != nil) {
        [parameters setObject:messageLength forKey:NAMES_messageLength];
    } else {
        [parameters removeObjectForKey:NAMES_messageLength];
    }
}

- (NSNumber *)messageLength {
    return [parameters objectForKey:NAMES_messageLength];
}

- (void)setMessageData:(NSMutableArray *)messageData {
    if (messageData != nil) {
        [parameters setObject:messageData forKey:NAMES_messageData];
    } else {
        [parameters removeObjectForKey:NAMES_messageData];
    }
}

- (NSMutableArray *)messageData {
    return [parameters objectForKey:NAMES_messageData];
}

@end
