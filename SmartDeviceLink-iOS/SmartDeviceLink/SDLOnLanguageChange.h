//  SDLOnLanguageChange.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCNotification.h"

#import "SDLLanguage.h"

@interface SDLOnLanguageChange : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLLanguage* language;
@property(strong) SDLLanguage* hmiDisplayLanguage;

@end
