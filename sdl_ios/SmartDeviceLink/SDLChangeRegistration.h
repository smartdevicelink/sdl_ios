//  SDLChangeRegistration.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

#import <SmartDeviceLink/SDLLanguage.h>

@interface SDLChangeRegistration : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLLanguage* language;
@property(strong) SDLLanguage* hmiDisplayLanguage;

@end
