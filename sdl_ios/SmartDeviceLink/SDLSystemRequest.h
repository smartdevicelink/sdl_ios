//  SDLSystemRequest.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

#import <SmartDeviceLink/SDLRequestType.h>
/** An asynchronous request from the device; binary data can be included in hybrid part of message for some requests<br> (such as HTTP, Proprietary, or Authentication requests)
 * <p>
 * @Since AppLink 3.0
 *
 */

@interface SDLSystemRequest : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLRequestType* requestType;
@property(strong) NSString* fileName;

@end
