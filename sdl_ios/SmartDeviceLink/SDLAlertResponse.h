//  SDLAlertResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLAlertResponse is sent, when SDLAlert has been called
 *
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLAlertResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* tryAgainTime;

@end
