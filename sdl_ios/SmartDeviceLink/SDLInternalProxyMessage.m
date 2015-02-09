//
//  SDLInternalProxyMessage.m
//  SmartDeviceLink
//
//  Created by Militello, Kevin (K.) on 12/17/14.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLInternalProxyMessage.h"

NSString* const SDLInternalProxyMessageOnProxyErrorKey = @"OnProxyError";
NSString* const SDLInternalProxyMessageOnProxyOpenedKey = @"OnProxyOpened";
NSString* const SDLInternalProxyMessageOnProxyClosedKey = @"OnProxyClosed";

@interface SDLInternalProxyMessage()

@property (strong, nonatomic) NSString* functionName;

@end

@implementation SDLInternalProxyMessage

-(instancetype)initWithFunctionName:(NSString *)functionName{
    
    self = [super init];
    
    if (self) {
        _functionName = functionName;
    }
    
    return self;
}

@end
