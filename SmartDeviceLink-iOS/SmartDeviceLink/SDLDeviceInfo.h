//  SDLDeviceInfo.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

@interface SDLDeviceInfo : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* hardware;
@property(strong) NSString* firmwareRev;
@property(strong) NSString* os;
@property(strong) NSString* osVersion;
@property(strong) NSString* carrier;
@property(strong) NSNumber* maxNumberRFCOMMPorts;

@end
