//  SDLRPCMessage.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>
#import "NSMutableDictionary+setOrRemove.h"

@interface SDLRPCStruct : NSObject {
	NSMutableDictionary* store;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict;
-(id) init;

-(NSMutableDictionary*) serializeAsDictionary:(Byte) version;

@end

@interface SDLRPCMessage : SDLRPCStruct {
	NSMutableDictionary* function;
	NSMutableDictionary* parameters;
	NSString* messageType;
}

-(id) initWithName:(NSString*) name;
-(id) initWithDictionary:(NSMutableDictionary*) dict;
-(NSString*) getFunctionName;
-(void) setFunctionName:(NSString*) functionName;
-(NSObject*) getParameters:(NSString*) functionName;
-(void) setParameters:(NSString*) functionName value:(NSObject*) value;

@property(strong) NSData* bulkData;
@property(strong, readonly) NSString* name;
@property(strong, readonly) NSString* messageType;

@end