//
//  SDLInternalProxyMessage.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLProtocolMessage.h>

extern NSString* const SDLInternalProxyMessageOnProxyError;
extern NSString* const SDLInternalProxyMessageOnProxyOpened;
extern NSString* const SDLInternalProxyMessageOnProxyClosed;

@interface SDLInternalProxyMessage : SDLProtocolMessage

-(instancetype)initWithFunctionName:(NSString*)functionName;

@property (strong, nonatomic, readonly) NSString* functionName;

@end
