//  SDLAddCommand.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCRequest.h"

#import "SDLMenuParams.h"
#import "SDLImage.h"

@interface SDLAddCommand : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* cmdID;
@property(strong) SDLMenuParams* menuParams;
@property(strong) NSMutableArray* vrCommands;
@property(strong) SDLImage* cmdIcon;

@end
