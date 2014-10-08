//  SDLCreateInteractionChoiceSet.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

@interface SDLCreateInteractionChoiceSet : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* interactionChoiceSetID;
@property(strong) NSMutableArray* choiceSet;

@end
