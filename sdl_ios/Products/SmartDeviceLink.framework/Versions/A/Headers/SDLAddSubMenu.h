//  SDLAddSubMenu.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

@interface SDLAddSubMenu : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* menuID;
@property(strong) NSNumber* position;
@property(strong) NSString* menuName;

@end
