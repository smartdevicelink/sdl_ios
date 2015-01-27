//  SDLChangeRegistration.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCRequest.h"

#import "SDLLanguage.h"

@interface SDLChangeRegistration : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLLanguage* language;
@property(strong) SDLLanguage* hmiDisplayLanguage;

@end
