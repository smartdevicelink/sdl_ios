//
//  SDLEncryptionConfiguration.h
//  SmartDeviceLink
//
//  Created by standa1 on 6/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLSecurityType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLEncryptionConfiguration : NSObject <NSCopying>

/**
 *  A set of security managers used to encrypt traffic data. Each OEM has their own proprietary security manager.
 */
@property (copy, nonatomic, nullable) NSArray<Class<SDLSecurityType>> *securityManagers;

/**
 *  Creates a default encryption configuration.
 *
 *  @return A default configuration that may be customized.
 */
+ (instancetype)defaultConfiguration;

/**
 Creates a secure configuration for each of the security managers provided.
 
 @param securityManagers The security managers to be used.
 @return The configuration
 */
- (instancetype)initWithSecurityManagers:(nullable NSArray<Class<SDLSecurityType>> *)securityManagers;

@end

NS_ASSUME_NONNULL_END
