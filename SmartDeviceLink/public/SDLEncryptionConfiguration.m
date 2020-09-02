//
//  SDLEncryptionConfiguration.m
//  SmartDeviceLink
//
//  Created by standa1 on 6/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEncryptionConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLEncryptionConfiguration

+ (instancetype)defaultConfiguration {
    return [[self.class alloc] initWithSecurityManagers:nil delegate:nil];
}

- (instancetype)initWithSecurityManagers:(nullable NSArray<Class<SDLSecurityType>> *)securityManagers delegate:(nullable id<SDLServiceEncryptionDelegate>)delegate {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _securityManagers = securityManagers;
    _delegate = delegate;
    
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLEncryptionConfiguration *newConfig = [[self.class allocWithZone:zone] init];
    
    newConfig.securityManagers = self.securityManagers;
    newConfig.delegate = self.delegate;
    
    return newConfig;
}


@end

NS_ASSUME_NONNULL_END
