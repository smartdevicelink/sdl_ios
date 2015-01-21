//  SDLDeleteFileResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Delete File Response is sent, when DeleteFile has been called
 *
 * Since <b>AppLink 2.0</b><br>
 */
@interface SDLDeleteFileResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* spaceAvailable;

@end
