//
//  SDLFakeSecurityManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/15/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLSecurityType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFakeSecurityManager : NSObject <SDLSecurityType>

@property (copy, nonatomic) NSString *appId;

- (void)initializeWithAppId:(NSString *)appId completionHandler:(void (^)(NSError *_Nullable error))completionHandler;
- (void)stop;

- (nullable NSData *)runHandshakeWithClientData:(NSData *)data error:(NSError **)error;

- (nullable NSData *)encryptData:(NSData *)data withError:(NSError **)error;
- (nullable NSData *)decryptData:(NSData *)data withError:(NSError **)error;

+ (NSSet<NSString *> *)availableMakes;

@end

NS_ASSUME_NONNULL_END
