//  SDLReadDIDResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Read DID Response is sent, when ReadDID has been called
 *
 * Since AppLink 2.0
 */
@interface SDLReadDIDResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* didResult;

@end
