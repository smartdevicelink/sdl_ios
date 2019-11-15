//
//  SDLServiceEncryptionDelegate.h
//  SmartDeviceLink
//
//  Created by Tanda, Satbir (S.S.) on 9/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLProtocolConstants.h"

NS_ASSUME_NONNULL_BEGIN

/// Delegate for the encryption service.
@protocol SDLServiceEncryptionDelegate <NSObject>

/**
 *  Called when the encryption service has been.
 *
 *  @param type will return whichever type had an encryption update (for now probably only SDLServiceTypeRPC), but it could also apply to video / audio in the future.
 *  @param encrypted return true if the the encryption service was setup successfully, will return false if the service is presently not encrypted.
 *  @param error will return any error that happens or nil if there is no error.
 */
- (void)serviceEncryptionUpdatedOnService:(SDLServiceType)type encrypted:(BOOL)encrypted error:(NSError *__nullable)error NS_SWIFT_NAME(serviceEncryptionUpdated(serviceType:isEncrypted:error:));

@end

NS_ASSUME_NONNULL_END
