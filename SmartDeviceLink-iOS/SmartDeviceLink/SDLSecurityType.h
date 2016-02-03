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

- (void)startWithCompletionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
- (void)stop;

- (NSData *)encryptData:(NSData *)data withError:(NSError **)error;
- (NSData *)decryptData:(NSData *)data withError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
