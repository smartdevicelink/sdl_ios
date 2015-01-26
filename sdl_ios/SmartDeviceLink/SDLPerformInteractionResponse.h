//  SDLPerformInteractionResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCResponse.h"

#import "SDLTriggerSource.h"

@interface SDLPerformInteractionResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* choiceID;
@property(strong) NSString* manualTextEntry;
@property(strong) SDLTriggerSource* triggerSource;

@end
