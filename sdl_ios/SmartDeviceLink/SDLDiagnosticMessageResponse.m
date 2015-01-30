//  SDLDiagnosticMessageResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDiagnosticMessageResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDiagnosticMessageResponse

-(id) init {
    if (self = [super initWithName:NAMES_DiagnosticMessage]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setMessageDataResult:(NSMutableArray *)messageDataResult {
    [parameters setOrRemoveObject:messageDataResult forKey:NAMES_messageDataResult];
}

-(NSMutableArray*) messageDataResult {
    return [parameters objectForKey:NAMES_messageDataResult];
}

@end
