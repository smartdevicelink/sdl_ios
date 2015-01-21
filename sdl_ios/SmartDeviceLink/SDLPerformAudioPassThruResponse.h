//  SDLPerformAudioPassThruResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Perform Audio Pass Thru Response is sent, when PerformAudioPassThru has been called
 *
 * Since AppLink 2.0
 */
@interface SDLPerformAudioPassThruResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLPerformAudioPassThruResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLPerformAudioPassThruResponse object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
