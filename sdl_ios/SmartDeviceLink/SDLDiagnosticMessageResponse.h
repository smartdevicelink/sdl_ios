//  SDLDiagnosticMessageResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLDiagnosticMessageResponse is sent, when SDLDiagnosticMessage has been called.
 * Since<b>AppLink 3.0</b>
 */
@interface SDLDiagnosticMessageResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* messageDataResult;

@end
