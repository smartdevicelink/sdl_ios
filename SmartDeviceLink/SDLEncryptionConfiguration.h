//
//  SDLEncryptionConfiguration.h
//  SmartDeviceLink
//
//  Created by standa1 on 6/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLServiceEncryptionDelegate.h"

@protocol SDLSecurityType;

NS_ASSUME_NONNULL_BEGIN

/// The encryption configuration data
@interface SDLEncryptionConfiguration : NSObject <NSCopying>

/**
 *  A set of security managers used to encrypt traffic data. Each OEM has their own proprietary security manager.
 */
@property (copy, nonatomic, nullable) NSArray<Class<SDLSecurityType>> *securityManagers;

/**
 *  A delegate callback that will tell you when an acknowledgement has occurred for starting as secure service.
 */
@property (weak, nonatomic, nullable) id<SDLServiceEncryptionDelegate> delegate;

/**
 *  Creates a default encryption configuration.
 *
 *  @return A default configuration that may be customized.
 */
+ (instancetype)defaultConfiguration;

/**
 Creates a secure configuration for each of the security managers provided.
 
 @param securityManagers The security managers to be used.
 @param delegate The delegate callback.
 @return The configuration
 */
- (instancetype)initWithSecurityManagers:(nullable NSArray<Class<SDLSecurityType>> *)securityManagers delegate:(nullable id<SDLServiceEncryptionDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
