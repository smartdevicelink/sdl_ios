//
//  SDLSecurityType.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/2/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A protocol used by SDL Security libraries.

 @warning Used internally
 */
@protocol SDLSecurityType <NSObject>

/**
 The app id of the app
 */
@property (copy, nonatomic) NSString *appId;

/**
 Initialize the SDL security library with the app's id and a completion handler

 @param appId The app's id
 @param completionHandler A handler for when the security library is initialized
 */
- (void)initializeWithAppId:(NSString *)appId completionHandler:(void (^)(NSError *_Nullable error))completionHandler;

/**
 Stop the security library
 */
- (void)stop;

/**
 Run the SSL/TLS handshake

 @param data The client data for the handshake
 @param error A returnable error
 @return The server handshake data
 */
- (nullable NSData *)runHandshakeWithClientData:(NSData *)data error:(NSError **)error;

/**
 Encrypt data using SSL/TLS

 @param data The data to encrypt
 @param error A returnable error
 @return The encrypted data
 */
- (nullable NSData *)encryptData:(NSData *)data withError:(NSError **)error;

/**
 Decrypt data using SSL/TLS

 @param data The data to decrypt
 @param error A returnable error
 @return The decrypted data
 */
- (nullable NSData *)decryptData:(NSData *)data withError:(NSError **)error;

/**
 The vehicle makes this security library covers

 @return The makes
 */
+ (NSSet<NSString *> *)availableMakes;

@end

NS_ASSUME_NONNULL_END
