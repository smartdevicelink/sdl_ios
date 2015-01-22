//  SDLDeleteSubMenuResponse.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLDeleteSubMenuResponse is sent, when SDLDeleteSubMenu has been called
 *
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLDeleteSubMenuResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
