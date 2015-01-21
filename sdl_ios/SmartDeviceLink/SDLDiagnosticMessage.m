//  SDLDiagnosticMessage.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDiagnosticMessage.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDiagnosticMessage

-(id) init {
    if (self = [super initWithName:NAMES_DiagnosticMessage]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setTargetID:(NSNumber *)targetID {
    [parameters setOrRemoveObject:targetID forKey:NAMES_targetID];
}

-(NSNumber*) targetID {
    return [parameters objectForKey:NAMES_targetID];
}

- (void)setMessageLength:(NSNumber *)messageLength {
    [parameters setOrRemoveObject:messageLength forKey:NAMES_messageLength];
}

-(NSNumber*) messageLength {
    return [parameters objectForKey:NAMES_messageLength];
}

- (void)setMessageData:(NSMutableArray *)messageData {
    [parameters setOrRemoveObject:messageData forKey:NAMES_messageData];
}

-(NSMutableArray*) messageData {
    return [parameters objectForKey:NAMES_messageData];
}

@end
