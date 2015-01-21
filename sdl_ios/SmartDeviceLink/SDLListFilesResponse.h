//  SDLListFilesResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLListFilesResponse is sent, when SDLListFiles has been called
 *
 * Since <b>AppLink 2.0</b>
 */
@interface SDLListFilesResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* filenames;
@property(strong) NSNumber* spaceAvailable;

@end
