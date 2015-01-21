//  SDLListFiles.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

/**
 * Requests the current list of resident filenames for the registered app. Not
 * supported on First generation SYNC vehicles
 * <p>
 *
 * Since <b>AppLink 2.0</b>
 */
@interface SDLListFiles : SDLRPCRequest {}

/**
 * Constructs a new SDLListFiles object
 */
-(id) init;
/**
 * Constructs a new SDLListFiles object indicated by the NSMutableDictionary parameter
 * <p>
 *
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
