//
//  SDLOnProxyClosed.h
//  SmartDeviceLink
//
//  Copyright (c) 2015 FMC. All rights reserved.
//

#import "SDLInternalProxyMessage.h"
#import "SDLDisconnectReason.h"

@interface SDLOnProxyClosed : SDLInternalProxyMessage

-(instancetype)initWithInfo:(NSString*)info error:(NSError*)error reason:(SDLDisconnectReason)reason;

@property (strong, nonatomic, readonly) NSString* info;
@property (nonatomic, readonly) SDLDisconnectReason reason;
@property (strong, nonatomic, readonly) NSError* error;

@end
