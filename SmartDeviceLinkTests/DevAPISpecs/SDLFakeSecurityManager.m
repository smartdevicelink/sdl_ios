//
//  SDLFakeSecurityManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/15/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLFakeSecurityManager.h"

@implementation SDLFakeSecurityManager

- (void)initializeWithAppId:(NSString *)appId completionHandler:(void (^)(NSError *_Nullable error))completionHandler {

}

- (void)stop {

}

- (nullable NSData *)runHandshakeWithClientData:(NSData *)data error:(NSError **)error {
    return nil;
}

- (nullable NSData *)encryptData:(NSData *)data withError:(NSError **)error {
    return nil;
}

- (nullable NSData *)decryptData:(NSData *)data withError:(NSError **)error {
    return nil;
}

+ (NSSet<NSString *> *)availableMakes {
    return [NSSet setWithObject:@"SDL"];
}

@end
