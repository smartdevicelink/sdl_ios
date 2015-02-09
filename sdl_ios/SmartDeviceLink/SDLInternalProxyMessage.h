//
//  SDLInternalProxyMessage.h
//  SmartDeviceLink
//
//  Created by Militello, Kevin (K.) on 12/17/14.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLProtocolMessage.h>

extern NSString* const SDLInternalProxyMessageOnProxyErrorKey;
extern NSString* const SDLInternalProxyMessageOnProxyOpenedKey;
extern NSString* const SDLInternalProxyMessageOnProxyClosedKey;

@interface SDLInternalProxyMessage : SDLProtocolMessage

-(instancetype)initWithFunctionName:(NSString*)functionName;

@property (strong, nonatomic, readonly) NSString* functionName;

@end
