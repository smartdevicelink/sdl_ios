//  SDLUnsubscribeButtonResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Unsubscribe Button Response is sent, when SDLUnsubscribeButton has been called
 *
 * Since AppLink 1.0
 */
@interface SDLUnsubscribeButtonResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLUnsubscribeButtonResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLUnsubscribeButtonResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
