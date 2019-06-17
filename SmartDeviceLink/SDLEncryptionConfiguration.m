//
//  SDLEncryptionConfiguration.m
//  SmartDeviceLink
//
//  Created by standa1 on 6/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEncryptionConfiguration.h"

@implementation SDLEncryptionConfiguration

+ (instancetype)unencryptedConfiguration {
    return [[self.class alloc] initWithSecurityManagers: nil];
}

- (instancetype)initWithSecurityManagers:(nullable NSArray<Class<SDLSecurityType>> *)securityManagers {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _securityManagers = securityManagers;
    
    return self;
}

@end
