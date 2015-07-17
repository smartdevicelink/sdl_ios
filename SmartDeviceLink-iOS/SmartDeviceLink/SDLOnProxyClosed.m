//
//  SDLOnProxyClosed.m
//  SmartDeviceLink
//
//  Copyright (c) 2015 FMC. All rights reserved.
//

#import "SDLOnProxyClosed.h"

@implementation SDLOnProxyClosed

-(instancetype)initWithInfo:(NSString*)info error:(NSError*)error reason:(SDLDisconnectReason)reason{
    self = [super initWithFunctionName:SDLInternalProxyMessageOnProxyClosed];
    if (self) {
        _info = info;
        _error = error;
        _reason = reason;
    }
    return self;
}

@end
