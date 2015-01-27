//  SDLAlertManeuver.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCRequest.h"

@interface SDLAlertManeuver : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* ttsChunks;
@property(strong) NSMutableArray* softButtons;

@end
