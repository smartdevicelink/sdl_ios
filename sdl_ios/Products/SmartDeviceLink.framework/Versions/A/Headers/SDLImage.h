//  SDLImage.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLImageType.h>

@interface SDLImage : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* value;
@property(strong) SDLImageType* imageType;

@end
