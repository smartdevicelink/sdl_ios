//
//  SDLTCPConfig.m
//  SmartDeviceLink-Example-ObjC
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import "SDLTCPConfig.h"

@implementation SDLTCPConfig

+ (instancetype)configWithHost:(NSString*)host port:(UInt16)port {
    return [[self alloc] initWithHost:host port:port];
}

- (instancetype)initWithHost:(NSString*)host port:(UInt16)port {
    if ((self = [super init])) {
        _ipAddress = host;
        _port = port;
    }
    return self;
}

@end
