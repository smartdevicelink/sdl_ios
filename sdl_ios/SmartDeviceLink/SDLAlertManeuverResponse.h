//  SDLAlertManeuverResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLAlertManeuverResponse is sent, when SDLAlertManeuver has been called.
 *<p>
 * Since<b>AppLink 1.0</b>
 */
@interface SDLAlertManeuverResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
