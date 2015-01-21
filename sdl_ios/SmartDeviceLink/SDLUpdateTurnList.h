//  SDLUpdateTurnList.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

/** Updates the list of next maneuvers, which can be requested by the user pressing the softbutton<br>
 * “Turns” on the Navigation base screen. Three softbuttons are predefined by the system: Up, Down, Close.
 *<p>
 * @Since AppLink 2.0
 */
@interface SDLUpdateTurnList : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* turnList;
@property(strong) NSMutableArray* softButtons;

@end
