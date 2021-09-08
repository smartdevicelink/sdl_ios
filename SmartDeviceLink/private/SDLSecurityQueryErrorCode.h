//
//  SDLSecurityQueryErrorCode.h
//  SmartDeviceLink
//
//  Created by Frank Elias on 8/12/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

typedef SDLEnum SDLSecurityQueryErrorCode NS_TYPED_ENUM;

///Internal Security Manager value
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeSuccess;

///Wrong size of query data
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeInvalidQuerySize;

///Unknown Query ID
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeInvalidQueryID;

///SDL does not support encryption
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeNotSupported;

///Received request to protect a service that was protected before
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeServiceAlreadyProtected;

///Received handshake or encrypted data for not protected service
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeServiceNotProtected;

///Decryption failed
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeDecryptionFailed;

///Encryption failed
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeEncryptionFailed;

///SSL invalid data
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeSSLInvalidData;

///In case of all other handshake errors
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeHandshakeFailed;

///Handshake failed because certificate is invalid
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeInvalidCertificate;

///Handshake failed because certificate is expired
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeExpiredCertificate;

///Internal error
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeInternal;

///Error value for testing
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCodeUnknownInternalError;


@interface SDLSecurityQueryError : NSObject

/**
 Compare the internal error ID with the App's security query error codes
 */
+ (SDLSecurityQueryErrorCode)convertErrorIdToStringEnum:(NSNumber *)errorId;

@end
