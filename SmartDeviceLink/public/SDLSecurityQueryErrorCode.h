//
//  SDLSecurityQueryErrorCode.h
//  SmartDeviceLink
//
//  Created by Frank Elias on 8/12/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

typedef SDLEnum SDLSecurityQueryErrorCode NS_TYPED_ENUM;

/**
 Internal Security Manager value
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_SUCCESS;
/**
 Wrong size of query data
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_INVALID_QUERY_SIZE;
/**
 Unknown Query ID
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_INVALID_QUERY_ID;
/**
 SDL does not support encryption
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_NOT_SUPPORTED;
/**
 Received request to protect a service that was protected before
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_SERVICE_ALREADY_PROTECTED;
/**
 Received handshake or encrypted data for not protected service
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_SERVICE_NOT_PROTECTED;
/**
 Decryption failed
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_DECRYPTION_FAILED;

/**
 Encryption failed
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_ENCRYPTION_FAILED;

/**
 SSL invalid data
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_SSL_INVALID_DATA;

/**
 In case of all other handshake errors
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_HANDSHAKE_FAILED;

/**
 Handshake failed because certificate is invalid
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_INVALID_CERT;

/**
 Handshake failed because certificate is expired
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_EXPIRED_CERT;

/**
 Internal error
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_INTERNAL;

/**
 Error value for testing
 */
extern SDLSecurityQueryErrorCode const SDLSecurityQueryErrorCode_UNKNOWN_INTERNAL_ERROR;
