//  SDLDiagnosticMessage.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCRequest.h"

@interface SDLDiagnosticMessage : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* targetID;
@property(strong) NSNumber* messageLength;
@property(strong) NSMutableArray* messageData;

@end
