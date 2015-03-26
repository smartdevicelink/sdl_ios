//  SDLUpdateTurnList.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

@interface SDLUpdateTurnList : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* turnList;
@property(strong) NSMutableArray* softButtons;

@end
