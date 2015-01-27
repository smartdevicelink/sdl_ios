//  SDLPresetBankCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

@interface SDLPresetBankCapabilities : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* onScreenPresetsAvailable;

@end
