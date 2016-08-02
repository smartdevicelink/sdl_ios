//
//  SDLSecurityType.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/2/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLSecurityType <NSObject>

- (void)initializeWithAppId:(NSString *)appId completionHandler:(void (^)(NSError *_Nullable error))completionHandler;
- (void)stop;

- (nullable NSData *)runHandshakeWithClientData:(NSData *)data error:(NSError **)error;

- (nullable NSData *)encryptData:(NSData *)data withError:(NSError **)error;
- (nullable NSData *)decryptData:(NSData *)data withError:(NSError **)error;

+ (NSSet<NSString *> *)availableMakes;

@end

NS_ASSUME_NONNULL_END
