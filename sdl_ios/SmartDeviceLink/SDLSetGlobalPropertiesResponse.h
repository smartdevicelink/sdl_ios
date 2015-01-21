//  SDLSetGlobalPropertiesResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Set Global Properties Response is sent, when SDLSetGlobalProperties has been called
 *
 * Since AppLink 1.0
 */
@interface SDLSetGlobalPropertiesResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLSetGlobalPropertiesResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLSetGlobalPropertiesResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
